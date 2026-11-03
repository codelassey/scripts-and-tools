# Broken Brute-Force Protection Bypass - Counter-Based Lockout Wordlist Builder

A suite of two Python utilities for exploiting **counter-based account lockout mechanisms** via credential interleaving. Both tools generate synchronized Pitchfork wordlists for Burp Suite Intruder. The difference between them is the injection strategy - specifically, where the reset credential lands relative to the lockout window and how aggressively it defends the counter.

---

## The Vulnerability: Counter-Based Lockout

Many web applications implement brute-force protection by counting consecutive failed login attempts per account. Once that count hits a defined threshold (e.g., 3 failed attempts), the account is temporarily or permanently locked.

**The flaw:** the counter resets on a successful login.

If an attacker knows one valid credential pair for *any* account on the system, they can inject that valid login into the request stream at precise intervals thereby resetting the server's failed-attempt counter before it reaches the lockout threshold while continuing to brute-force a separate victim account indefinitely.

---

## The Two Scripts

### `interleave_wordlist_generator_1.py` - Reset Before Window (Configurable Threshold)

Injects the reset credential at the **start of every victim attempt window**. The window size is derived from the lockout threshold: `window_size = threshold - 1`. The counter is zeroed before any victim attempt in the window lands.

**Alignment matrix (threshold = 5, window = 4):**

| Row | Username | Password | Result |
|-----|----------|----------|--------|
| 1 | reset_user | reset_pass | SUCCESS - counter: 0 |
| 2 | victim_user | candidate_001 | FAIL - counter: 1 |
| 3 | victim_user | candidate_002 | FAIL - counter: 2 |
| 4 | victim_user | candidate_003 | FAIL - counter: 3 |
| 5 | victim_user | candidate_004 | FAIL - counter: 4 |
| 6 | reset_user | reset_pass | SUCCESS - counter: 0 |
| 7 | victim_user | candidate_005 | FAIL - counter: 1 |
| ... | | | |

**Use when:**
- The lockout threshold is confirmed and high enough (4+) to make multi-attempt windows worthwhile
- You want to minimise total request volume and reduce noise in logs
- You have confidence in the exact threshold value - miscounting it by one triggers a lockout

---

### `interleave_wordlist_generator_2.py` - Strict 1:1 Alternating (Ultra-Safe)

Injects the reset credential **before every single victim attempt**. Every odd-numbered row is a successful reset. Every even-numbered row is a victim candidate. The counter never exceeds 1 consecutive failure regardless of the threshold.

**Alignment matrix:**

| Row | Username | Password | Result |
|-----|----------|----------|--------|
| 1 | reset_user | reset_pass | SUCCESS - counter: 0 |
| 2 | victim_user | candidate_001 | FAIL - counter: 1 |
| 3 | reset_user | reset_pass | SUCCESS - counter: 0 |
| 4 | victim_user | candidate_002 | FAIL - counter: 1 |
| 5 | reset_user | reset_pass | SUCCESS - counter: 0 |
| 6 | victim_user | candidate_003 | FAIL - counter: 1 |
| ... | | | |

**Critical anchor rule:** The reset credential must be on Row 1. If the sequence starts with a victim attempt (a failure), the server's counter opens at 1 before any reset has fired. On a threshold of 3, that shifts the lockout boundary one row earlier than expected - flipping the entire sequence out of alignment and triggering a lockout on the third victim attempt regardless of the injection pattern.

**Use when:**
- The lockout threshold is unknown or low (2–3 attempts)
- The target application's counter behaviour is unclear or inconsistent
- Reliability matters more than request volume - this pattern cannot trigger a lockout under any threshold ≥ 2

---

## Choosing the Right Script

| Condition | Script |
|---|---|
| Threshold is unknown | `generator_2` - safer default |
| Threshold is low (2–3 attempts) | `generator_2` |
| Threshold is confirmed and higher (4+) | `generator_1` |
| Minimising total request volume matters | `generator_1` |
| First request to the server must be a success | `generator_2` - enforced by design |

---

## Requirements

- Python 3.10+
- Standard library only - no external dependencies

---

## Usage

```bash
# Configurable window (threshold-driven)
python3 interleave_wordlist_generator_1.py <passwords.txt>

# Strict 1:1 alternating (ultra-safe)
python3 interleave_wordlist_generator_2.py <passwords.txt>
```

**You will be prompted for:**

- **Victim username** - the account being brute-forced
- **Reset username** - the account used purely to reset the counter
- **Reset password** - its password (input is hidden)
- **Lockout threshold** - `generator_1` only; `generator_2` does not require it

**Output files written to the current directory:**

```
interleaved_users.txt
interleaved_passwords.txt
```

---

## Burp Suite Intruder - Pitchfork Setup

### 1. Capture & Send to Intruder

Capture a login request via the Proxy and send it to Intruder (`Ctrl+I`).

### 2. Positions Tab

- Set **Attack type -> Pitchfork**
- Highlight the username field value -> click **Add §** - this becomes **Payload Position 1**
- Highlight the password field value -> click **Add §** - this becomes **Payload Position 2**

### 3. Payloads Tab

- **Payload set 1** -> Type: `Simple list` -> Load `interleaved_users.txt`
- **Payload set 2** -> Type: `Simple list` -> Load `interleaved_passwords.txt`
- Confirm both lists show the **same line count** in the UI before continuing

### 4. Resource Pool Tab

> **Why you need a new resource pool**
>
> By default, Burp Intruder sends requests in parallel across multiple connections simultaneously. For this attack, parallel requests will break the exploit entirely.
>
> You must create a resource pool restricted to **1 maximum concurrent request** for two reasons:
>
> - **Strict execution order:** The Pitchfork attack relies on absolute row order. The reset request must arrive at the server *and finish processing* before the next victim attempt is sent. If Burp fires multiple requests simultaneously, the server may process a victim attempt before the reset lands - triggering a lockout and breaking the injection sequence entirely.
>
> - **Race conditions:** Web applications process failed-login tracking sequentially in the database. If requests overlap by even a few milliseconds, the application's internal counter may miscount attempts or fail to register the successful reset in time - causing the lockout to fire on the wrong boundary.

**Steps:**

- Open the **Resource Pool** tab in Intruder
- Click **Add** to create a new pool
- Set **Maximum concurrent requests: 1**
- Assign this pool to the current Intruder attack

### 5. Run the Attack

- Start the attack
- Monitor the **Status** column - reset rows (every odd-numbered row for `generator_2`, every window-opener row for `generator_1`) should return the application's success response code (`200`, `302`, etc.)
- When complete, filter out `200` responses - the valid credential hit for the victim account will stand out by status code or response length

---

## Legal Notice

This tool is intended for authorized penetration testing, bug bounty engagements, and security research against systems you own or have explicit written permission to test. Unauthorized use against systems you do not own is illegal.

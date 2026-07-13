# Extracts the Base64 payload from any given file
grep -o '"[A-Za-z0-9+/=]\{100,\}"' artifacts/stager.ps1 | tr -d '"' | \
  python3 -c "
import sys, base64
b64 = sys.stdin.read().strip()
print(base64.b64decode(b64).decode('utf-16-le'))
"

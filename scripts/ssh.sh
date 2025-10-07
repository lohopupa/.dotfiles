# eval $(ssh-agent -s) > /dev/null

# find ~/.ssh -type f ! -name "*.pub" | while read -r KEY; do
#     # Check for a private key header
#     if grep -qE "PRIVATE KEY-----" "$KEY"; then
#         ssh-add "$KEY" 2>/dev/null
#     fi
# done
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/copilot -C seni@cityplug.co.uk
ssh-copy-id -i ~/.ssh/copilot root@192.168.31.254

ansible all -m ping
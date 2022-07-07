#Get Domain administrators
crackmapexec smb IP -u 'user' -p 'pass' --groups 'Domain Admins' > log.admins
cat admins.txt | rev | cut -d " " -f1 | rev > admins-clean.txt
cat admins-clean.txt  | cut -d '\' -f2





#impacket-GetUserSPNs

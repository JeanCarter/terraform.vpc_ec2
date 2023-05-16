add-content -path c:/Users/Tipson/.ssh/config -value @'

Host ${hostname}
    HostName ${hostname}
    User ${user}
    IdentityFile ${Identityfile}
'@
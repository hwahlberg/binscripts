ldapsearch -LLL -x -b OU=Boliden,DC=boliden,DC=internal -h boldcr0003.boliden.internal "(&(objectclass=group)(cn=$1))" cn dn

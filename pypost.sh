#!/usr/bin/python3.4
#
# Small script to show PostgreSQL and Pyscopg together
#

import psycopg2

try:
    conn = psycopg2.connect("dbname='bbnthwa' user='bbnthwa' host='localhost' password='230volt'")
except:
    print ("I am unable to connect to the database")

try:
    cur = conn.cursor()
    cur.execute("""select * from tab2""")
    rows = cur.fetchall()
    print ("\nShow me the databases:\n")
    for row in rows:
      print (" %d:   " % row[0])
except psycopg2.OperationalError:
    print ("OperationalError")
except psycopg2.ProgrammingError:
    print ("ProgrammingError")
except psycopg2.DatabaseError:
    print ("DatabaseError")

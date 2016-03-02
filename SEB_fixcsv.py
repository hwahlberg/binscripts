import csv
import sys
import datetime

class myCSV():
    
    def splitText(self, s, ch):
        inx = 0
        cnt = 0
        i = 0
        for c in s:
            if c == ch:
                cnt += 1
                i = inx
            inx += 1
        t = s[:i]
        d = s[i+1:]
        try:
            datetime.datetime.strptime(d, '%y-%m-%d')
            d = "20" + d
        except ValueError:
            t = s
            d=""
        return (t,  d)
        
         
    def openAndRead(self, file):
        with open(file,'rb') as csvfile:
            sr = csv.reader(csvfile,delimiter=';')
            for row in sr:
                text = ""
                belopp_dag = ""
                if "/" in row[3]:
                    text,  belopp_dag = self.splitText(row[3],  '/')
                if len(belopp_dag) == 0:
                    belopp_dag = row[1]
                k4 = float(row[4])
                if k4 < 0:
                    belopp_in = ""
                    belopp_ut = k4*-1
                else:
                    belopp_in = k4
                    belopp_ut = ""
                print row[0] + ";" + row[1] + ";" + row[2] + ";" + text+ ";" + belopp_dag + ";" + str(belopp_in) + ";" + str(belopp_ut) + ";" + row[5]


if __name__ == '__main__':
    numargs = len(sys.argv)
    if numargs != 2:
        print "num args=" + str(len(sys.argv)) + "! Need csvfile"
        sys.exit(1)
        
    file = sys.argv[1]
    mycsv = myCSV()
    mycsv.openAndRead(file)

    
    

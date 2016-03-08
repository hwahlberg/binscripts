# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

import os
import sys
import subprocess

import argparse
import glob
from mimetypes import MimeTypes

acceptedImages=["image/jpeg", "image/png","image/tiff","image/gif"]

SourceDir="./"
#SourceDir=os.environ["HOME"] + "/tmp/"

# destination direcory, option -d.
DestDir=os.environ["HOME"] + "/Photos/original"

# Files to manage, default every file in SRCDIR
Files=""

# CreateDate, option -c
# Format "YYYY:MM:DD hh:mm:ss" alt "YYYY:MM:DD"

# Default filename format
FilenameFormat="%Y%m%d_%H%M%S%%-c.%%le" 

#
CreateDate=    ""
DoCreateDate = False
DoRename=     True
DoMove=          False
Verbose =         False


def parseArguments():
    global DestDir
    global DoCreateDate
    global CreateDate
    global Verbose
    global DoRename
    global DoMove
    global Files
    
    parser = argparse.ArgumentParser(description="Manage rename and import of images")    
    parser.add_argument("-v", "--verbose",      action="store_true")
    parser.add_argument("-m", "--move",         action="store_true", help="Move image to DESTDIR")
    parser.add_argument("-n", "--norename",  action="store_true",  help="No rename of image")
    parser.add_argument("-c", "--createdate",  help="set EXIF \"Create Date\" Tag")
    parser.add_argument("-d", "--destdir",  help="Destination directory when move")
    parser.add_argument("files",  nargs='+',  help="Files to manage")
    args = parser.parse_args()
    
    if args.destdir:
        DestDir = args.destdir

    if args.createdate:
        CreateDate = args.createdate
    
    if args.verbose:
        Verbose = True
        
    if args.norename:
        DoRename = False
        
    if args.move:
        DoMove = True
        
    Files = args.files


def checkVerbose():
    if Verbose == False:
        f = open(os.devnull, 'w')
        sys.stdout = f
        
    print "Verbose is %r" % Verbose



def checkCreateDate():
    global CreateDate
    global DoCreateDate
    global FilenameFormat
    
    if len(CreateDate) == 10:
        CreateDate = CreateDate + " 00:00:00"
        FilenameFormat = "%Y%m%d%%-c.%%le"
    
    if len(CreateDate) != 19:
        CreateDate = ""
        DoCreateDate = False
    
    if len(CreateDate) > 0:
        print "CreateDate is {} and len {}".format(CreateDate, len(CreateDate))
        DoCreateDate = True
    


def RenameImage(image, out,  err):
    global FilenameFormat

    print "Rename: " + image
    #prog = "/home/hwa/bin/myecho.sh"
    prog = "/usr/bin/exiftool"
    
    proc = subprocess.Popen([prog,  \
                                                "-FileName<CreateDate", \
                                                "-d", FilenameFormat, \
                                                "-P", \
                                                "-r", \
                                                image], \
                                                stdout=out, \
                                                stderr=err)
                                                
    #for line in proc.stdout:
     #   print "rename image :" + line

    proc.wait()


def NewCreateDate(newdate,  image, out,  err):
    print image + ": set new date: " + newdate 
    #prog = "/home/hwa/bin/myecho.sh"
    prog = "/usr/bin/exiftool"
    
    proc = subprocess.Popen([prog,  \
                                                "-CreateDate=\"" +newdate+ "\"", \
                                                "-P", \
                                                "-r", \
                                                "-overwrite_original_in_place",  \
                                                image], \
                                                stdout=out, \
                                                stderr=err)
                                                
    #for line in proc.stdout:
      #  print "NewCreateDate :" + line
     
    proc.wait()
     


def MoveImages(sourcedir,  destdir,  inodes,  out,  err):
    #prog = "/home/hwa/bin/myecho.sh"
    prog = "/usr/bin/exiftool"

#get the new name from inode
    lista = glob.glob(SourceDir + "*")
        
    for l in lista:
        st_ino = os.stat(l)[1]
        if st_ino in inodes:
            print "move image: " + l + ": inode: " + str(st_ino)
            proc = subprocess.Popen([prog,  \
                                                        "-Directory<CreateDate", \
                                                        "-d", destdir + "/%Y/%m%d", \
                                                        "-P", \
                                                        "-r", \
                                                        l], \
                                                        stdout=out, \
                                                        stderr=err)
            proc.wait()



if __name__ == "__main__":
    parseArguments()
    
    checkVerbose()
    print "DestDir is " + DestDir
    print "DoRename is %r" % DoRename
    print "DoMove is %r" % DoMove
    
    checkCreateDate()
    
    mime = MimeTypes()
        
    fdnull = os.open("/dev/null", os.O_WRONLY)
    inodlist = []
    for f in Files:
        lista = glob.glob(SourceDir + f)
        
        for l in lista:
            mt = mime.guess_type(l)
            mtype = mt[0]
            
            if mtype in acceptedImages:                
                st_ino = os.stat(l)[1]
                inodlist.append(st_ino)
                print "{}: mime={}, inode={}".format(l, mtype,st_ino) 
                
                if  DoCreateDate:
                    NewCreateDate(CreateDate,  l,  fdnull,  fdnull)
                
                if DoRename:
                    RenameImage(l, fdnull, fdnull)
                   
                
            
    if DoMove:
        MoveImages(SourceDir,  DestDir,  inodlist, fdnull,  fdnull)
        




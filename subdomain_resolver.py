import subprocess
import shlex
import re
from colorama import init, Fore, Back, Style
from termcolor import colored
import shutil


# Console colors
W  = '\033[0m'  # white (normal)
R  = '\033[31m' # red
G  = '\033[32m' # green
O  = '\033[33m' # orange
B  = '\033[34m' # blue
P  = '\033[35m' # purple
C  = '\033[36m' # cyan
GR = '\033[37m' # gray
Y = '\033[93m'
BOLD = '\033[1m'
END = '\033[0m'
init()
    

def main():
    subfile = input("Enter subdomain file name: ")
    fileopen = open(subfile,"r")
    file = fileopen.readlines()
    c = len(file)
    print (R+BOLD+"Total Count: "+END+BOLD+O+str(c)+END)
    for subdomain in file:
        cmd='dig +short '+subdomain
        proc=subprocess.Popen(shlex.split(cmd),stdout=subprocess.PIPE)
        out,err=proc.communicate()
        out = out.decode('utf-8')
        searchobj = re.search(r'(([0-9]{1,3}\.){3}[0-9]{1,3})', out, re.I)
        if searchobj:
            print(str(subdomain.rstrip()) + " : "+ str(searchobj.group(1)))
            resubdomain = (str(subdomain.rstrip()) + ","+ str(searchobj.group(1)))
            resolveddomain = open("resolvedsubdomain.csv","a")
            resolveddomain.write(resubdomain+"\n")

	       

if __name__ =='__main__':
	main()

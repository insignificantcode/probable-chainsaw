#!/usr/bin/env python
'''
    this script will scrape the symantec website to check the new
    symantec endpoint protection version, check our own system
    version and let us know if we are running the newest or not.
    nicholas.hunt@nasa.gov
'''

from __future__ import print_function, unicode_literals
from __future__ import absolute_import, division
from lxml import html
import requests
import os
import subprocess

savCommand = "/opt/Symantec/symantec_antivirus/sav info -p"
symLocalVersion = subprocess.check_output(savCommand, shell=True)

#symLocalVersion = "12.1.6 (12.1 RU6 MP7) build 7061 (12.1.7061.6600)"

response = requests.get('https://support.symantec.com/en_US/article.HOWTO101888.html')

if (response.status_code == 200):
    pagehtml = html.fromstring(response.text)
    version = (pagehtml.xpath('//div[@class="itemizedlist"]/ul/li/a/text()'))

symSiteVersion = version[0]

print("This system is running version:", symLocalVersion[8:20])
print("Symantec website's newest version:", symSiteVersion[:12] + "\n")

if symLocalVersion[8:20] == symSiteVersion[:12]:
    print('\x1b[6;30;42m' + 'Success!' + '\x1b[0m')
    print("We have the newest Symantec Endpoint Protection installed!!")
else:
    print('\x1b[0;37;41m' + 'Oh NO!' + '\x1b[0m')
    print("We are not running the newest Symantec Endpoint Protection version. :(")

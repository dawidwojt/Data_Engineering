# 20230915_powershell_file_organizer

This is a PowerShell script designed to sort files in a directory and show the most important statistics about folders.
First off, files are separated into folders based on datatypes.

![image](https://github.com/dawidwojt/Data_Engineering/assets/99885611/79ca9f3d-09ce-4ba7-94db-95ab9834b305)

Then statistics about each folder are returned in a console in the form of an array.

![image](https://github.com/dawidwojt/Data_Engineering/assets/99885611/d1636294-08e4-4ed0-9bac-b6ae0a430d62)

In the source, the script looks for file in C:\temp folder, yet it can be easily modified by just changing the value of two parameters so that the script can be used in other locations.

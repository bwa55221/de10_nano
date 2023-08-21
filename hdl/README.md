# How to import design into Quartus Standard 22.1

1. Create new empty project within Quartus Prime Standard 22.1
2. Choose a project directory, match the project name to that of the .qsf filename.
3. Add the above .vhd, .qsf, .sdc, and .qsys files to the project directory (overwriting the existing empty .qsf file).

![image](https://github.com/bwa55221/de10_nano/assets/142425608/cd4ccae2-1abc-4227-95fa-085e531a4d17|width=250px|height=250px)


4. Use platform designer to generate the soc_system VHDL.
5. Compile the design.

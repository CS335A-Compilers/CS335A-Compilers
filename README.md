<div id="top"></div>

<br />
<div align="center">

<h3 align="center">Parser for a Dissertation</h3>

  <p align="center">
    Implemented a parser for a dissertation which contains different paragraphs, sentences and sections and outputs the statistics and a table of contents.
    <br />
    <br />
    <a href="https://github.com/Deepak-Sangle/CS335A-Compilers">View Demo</a>
    ·
    <a href="https://github.com/Deepak-Sangle/CS335A-Compilers/issues">Report Bug</a>
    ·
    <a href="https://github.com/Deepak-Sangle/CS335A-Compilers/issues">Request Feature</a>
  </p>
</div>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#assumptions">Assumptions</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#evaluating-test-cases">Evaluating Test cases</a></li>
      </ul>
    </li>
      </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

The assignment deals with scanning and parsing the given text or dissertation and printing different statistics of the text like number of exclamatory sentences or number of chapters.

### Built With

* [Flex](https://github.com/westes/flex)
* [Bison](https://www.gnu.org/software/bison/)

## Assumptions

Before evaluating, please keep in mind the following assumptions for the assignment.

- Since it was given in assignment that there cannot be signed numbers, thus the positive and negative sign are illegal characters in the given text.
- There were lots of ambiguities regarding newlines and paragraphs. I have assumed the following convention. 2 or more than 2 Newlines must present between any two paragraphs. Other than that, at any place (for eg. between chapter and paragraph, chapter and section, section and paragraph), there must be 1 or more than 1 newline character used for seperation. This assumption is based on the information I collected on Piazza.

<!-- GETTING STARTED -->
## Getting Started

You can clone the repository using the github clone option or download the zip file directly. Then follow the following instruction to run the parser.

### Prerequisites

Your system must have latest version of flex and bison installed. In order to install it in Debian system, enter the following command in your terminal
  ```sh
  sudo apt-get install flex 
  sudo apt-get install bison
  ```

If you have any installation issues, you can refer to the [flex installation guide](https://github.com/westes/flex/blob/master/INSTALL.md) or [bison installation manual](https://www.gnu.org/software/bison/manual/).

### Evaluating Test cases

To evaluate different test cases present you simply need to follow the following instructions.

 Run the make clean command to start freshly.
  ```sh
  make clean
  ```

In order to evaluate the parser on some file (say filename.txt), enter the following command in the terminal.

  ```sh
  make ./filename.txt
  ```

If the above command doesn't work you can always enter the following four commands in order.

  ```sh
	bison -d q4.y
	flex q4.l
	gcc lex.yy.c q4.tab.c -o parser
	./parser.exe < filename.txt
  ```
  
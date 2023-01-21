<div id="top"></div>

<br />
<div align="center">

<h3 align="center">Lexical Analyzer for CSEIITK Language</h3>

  <p align="center">
    Implemented a lexical analyzer which identifies different tokens and their attributes.
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

Implemented a Lexical Analyzer for a toy programming language called CSEIITK. The Analyzer classifies each strings of input in different categories of token and also returns its count in a comma seperated file. 

### Built With

* [Flex](https://github.com/westes/flex)

## Assumptions

Before evaluating my lexical analyzer, one should keep in mind the following assumptions that I have made

- I have assumed that numeric literals like '2.' will give me '2' as a literal and '.' as an operator (This because I followed the rules mentioned in the assignment and didn't wanted to change my code completely after reading your comment on piazza). I will club this '2' and '.' literal during lexical parsing.
- I have assumed that '-' is only binary operator. Thus for unsigned numbers like -2, it will give '-' as an operator and '2' as a numeric literal. I will also club this '2' and '-' sign during lexical parsing.
- I have assumed that multiline strings are syntatically wrong (which in languages like C or C++ is) and thus my analyzer will throw error if such strings are found.
- One can refer to my defintion section of "la.l" file for many other ambiguous rules (like which excape sequences I have assumed to be present in this language and so on).

<!-- GETTING STARTED -->
## Getting Started

You can clone the repository using the github clone option or download the zip file directly. Then follow the following instruction to run the analyzer.

### Prerequisites

Your system must have latest version of flex installed. In order to install it in Debian system, enter the following command in your terminal
  ```sh
  sudo apt-get install flex 
  ```

If you have any installation issues, you can refer to the [flex installation guide](https://github.com/westes/flex/blob/master/INSTALL.md).

### Evaluating Test cases

To evaluate different test cases present as .335 extensions in this folder you simply need to follow the below instructions.

Firsly run make clean to start the repo freshly.
  ```sh
  make clean
  ```
Then in order to run, say 2nd test case file (assuming name of the file is public2.335), you can execute the following instruction
  ```sh
  make tc-2
  ```
Else if you want to evaluate using other files (say filename.335) you can execute the following instructions line by line
  ```sh
  flex la.l
  gcc lex.yy.c
  ./a.exe < ./filename.335
  ```
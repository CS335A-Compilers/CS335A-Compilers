<div id="top"></div>

<br />
<div align="center">

<h3 align="center">Lexical Analyzer for Java</h3>

  <p align="center">
    Implemented a lexical analyzer which identifies different tokens, their counts and attributes.
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

Implemented a Lexical Analyzer for Java. The Analyzer classifies each strings of input in different categories of token and also returns its count in a comma seperated file. 

### Built With

* [Flex](https://github.com/westes/flex)

## Assumptions

Before evaluating my lexical analyzer, one should keep in mind the following assumptions that I have made

- I have followed the [Official Java Manual](https://docs.oracle.com/javase/specs/jls/se17/html/jls-3.html) for creation of all the regular expressions.
- One should refer to the definition section of my "la.l" file for all the definition I had made for Java Lexer.

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

Firstly, if you have to change the current working directory by 
  ```sh
  cd Java-Lexer
  ```

 Then run the make clean command to start freshly.
  ```sh
  make clean
  ```

In order to evaluate the lexer on some file (say filename.java), enter the following command in the terminal.

  ```sh
  make ./filename.java
  ```

If the above command doesn't work you can always enter the following three commands in order.

  ```sh
  flex la.l
  gcc lex.yy.c
  ./a.exe < ./filename.java
  ```
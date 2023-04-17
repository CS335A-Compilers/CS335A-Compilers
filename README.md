<div id="top"></div>

<br />
<div align="center">

<h2 align="center">Compiler for Java</h2>
<!-- <h3 align="center">Milestone 1</h3> -->

  <p align="center">
    Implementing Compiler for Java language. 
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

We have implemented the lexical analayzer and parser for the Java language. The lexer returns various tokens and their lexemes to the bison parser where it matches the set of terminals with the java grammar. Finally, an Abstract Syntax Tree is created which shows different production rules which are applied to parse the java language. 

### Built With

* [Flex](https://github.com/westes/flex)
* [Bison](https://www.gnu.org/software/bison/manual/bison.html)
* [Graphviz](https://graphviz.org/)

<!-- GETTING STARTED -->
## Getting Started

You can clone the repository using the github clone option or download the zip file directly. Then follow the following instruction to run the analyzer.

### Prerequisites

Your system must have latest version of flex, bison and graphviz installed. In order to install it in Debian system, enter the following command in your terminal
  ```sh
  sudo apt-get install flex 
  sudo apt-get install bison
  sudo apt-get install graphviz
  ```

If you have any installation issues, you can refer to the [flex installation guide](https://github.com/westes/flex/blob/master/INSTALL.md) or [bison manual](https://www.gnu.org/software/bison/manual/bison.html).

### Evaluating Test cases

To evaluate different test cases present in tests folder you simply need to follow the below instructions.

Firstly, you have to change the current working directory.
  ```sh
  cd src
  ```

 Then compile the lexer and parser using makefile command.
  ```sh
  make 
  ```

In order to evaluate the code on some java file (with path "../tests/test_1.java") and output the ast in assembly file (with path "./test_1.s"), use the following command.

  ```sh
  ./java-assembler --input=../tests/test_1.java --output=./test_1.s
  ```

This will generate .csv files containing the symbol table for each method and the whole class as a whole. It will also generate a dump of the 3AC instructions in the file - `3ac.txt`

In order to vizualize the dot file in svg format, run the following command.

  ```sh
  dot -Tsvg test_1.3ac -o test_1.svg
  ```

If you want to use help flag, you can simply use the following command.

  ```sh
  ./java-assembler --help
  ```

If one wants to see how the stack contents are changing and which particular production rule is being used, one can use the following command. (Remeber that verbose command will work only when you give some input and output file to it.)

  ```sh
  ./java-assembler --input=../tests/test_1.java --output=test_1.dot --verbose
  ```

### Note

If the makefile does not compile properly, use the following commands,

  ```sh
	g++ lex.yy.c parser.tab.c ast.cpp helper.cpp symtab.cpp expression.cpp 3ac.cpp -o java-assembler
  ```
instead of 

  ```sh
	g++ lex.yy.c parser.tab.c ast.cpp helper.cpp symtab.cpp expression.cpp 3ac.cpp -o java-assembler
  ```

in the Makefile

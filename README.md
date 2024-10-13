![.Net](https://img.shields.io/badge/.NET-5C2D91?style=for-the-badge&logo=.net&logoColor=white)
![C#](https://img.shields.io/badge/c%23-%23239120.svg?style=for-the-badge&logo=csharp&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![InfluxDB](https://img.shields.io/badge/InfluxDB-22ADF6?style=for-the-badge&logo=InfluxDB&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Figma](https://img.shields.io/badge/figma-%23F24E1E.svg?style=for-the-badge&logo=figma&logoColor=white)
![Jira](https://img.shields.io/badge/jira-%230A0FFF.svg?style=for-the-badge&logo=jira&logoColor=white)
![Visual Studio](https://img.shields.io/badge/Visual%20Studio-5C2D91.svg?style=for-the-badge&logo=visual-studio&logoColor=white)
![Emacs](https://img.shields.io/badge/Emacs-%237F5AB6.svg?&style=for-the-badge&logo=gnu-emacs&logoColor=white)

# Overview 
*Data Acquisition and Development Tool* 

This Project aims to configure and monitor sensors as well as for data
storage the research project Smart Pacifier needs a Data Acquisition
and Development Tool.

# Table of Contents
- [Documentation](#documentation)
- [Style Guide for Code](#style-guide-for-code)

# Documentation

# Style Guide for Code

## Indentation
Use 4 spaces for indentation
	
We use spaces for indentation. Do not use tabs in your code. You should set your
editor to emit spaces when you hit the tab key.

## Naming Convention
- Classes: PascalCase (e.g., MyClass)
- Methods: PascalCase (e.g., MyMethod)
- Variables: camelCase (e.g., myVariable)
- Private Member Variables: _startingWithAUnderscore (e.g., _privateVariable)
- Constants: UPPERCASE_WITH_UNDERSCORES (e.g., MAX_VALUE)

## Braces
Each Braces goes in a separate line, starting after the statement.

## Line Length
Each line of text in your code should be at most 80 characters long.

A line may exceed 80 characters if it is:

- a comment line which is not feasible to split without harming readability,
  ease of cut and paste or auto-linking -- e.g., if a line contains an example
  command or a literal URL longer than 80 characters.
- a string literal that cannot easily be wrapped at 80 columns. This may be
  because it contains URIs or other semantically-critical pieces, or because the
  literal contains an embedded language, or a multiline literal whose newlines
  are significant like help messages. In these cases, breaking up the literal
  would reduce readability, searchability, ability to click links, etc. 
- an include statement.

## Comments
- Purpose: Explain the intent of code that is not immediately obvious.
- Style: Use clear and concise language.
- Types:
  - Single-line comments: Use //.
  - Multi-line comments: Use /* */.
  - XML comments: Use /// for documentation.
  
## Example
```c#
// Good code example
/// <summary>
/// Represents a backend service that creates and handles a database.
/// </summary>
public class BackendService
{
    public const string DATABASE_URL = "url";
    /// <summary>
    /// The underlying database connection.
    /// </summary>
    private readonly IDatabaseConnection _databaseConnection;

    /// <summary>
    /// Initializes a new instance of the <see cref="BackendService"/> class.
    /// </summary>
    /// <param name="databaseConnection">The database connection to use.</param>
    public BackendService(IDatabaseConnection databaseConnection)
    {
        _databaseConnection = databaseConnection;
    }
}

// Bad code example
public class BackendService
{
	public const string DATABASE_URL = "url";
	
	/* Database Connection */ 
    private readonly IDatabaseConnection databaseConnection;

    public BackendService(IDatabaseConnection databaseConnection){
        databaseConnection = databaseConnection;
    }
}
```

# PSTool - System Engineer's PowerShell Multitool

## Description

PSTool is a PowerShell script designed to help system engineers perform common tasks more efficiently. It provides a menu of tools that can be selected and executed from the command line.

## Usage

To use PSTool, simply run the script from your PowerShell command line:

```powershell
irm pstool.net | iex
```

This will display the `PSTool>` prompt. To get a menu of available tools, enter a search term, keyword or `?` and press Enter to list every tool available. Enter the identifyer of the tool (specified in `[brackets]`) you wish to use and press Enter. You will be asked to confirm before the tool is executed.

To exit the PSTool prompt, type `exit` and press Enter or press `ctrl + C`.
PSTool will automatically exit after a tool has been executed.

## Shortcuts

PSTool supports shortcuts to tools via URL parameters. This allows you to quickly access a specific tool without navigating through the menu.

To use this feature, append the tool's identifyer to the URL as a parameter. For example, to access `cmt`, you would use the following command:

```powershell
irm pstool.net?cmt | iex
```

## Contributing

If you have a tool you'd like to add, or if you've found a bug, please open an issue or submit a pull request.

## License

PSTool is licensed under the MIT License. See LICENSE for more information.
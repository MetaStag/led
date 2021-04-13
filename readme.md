## led

led is an ed clone written in lua!

---

##### What is ed?
ed is a very old text editor, made in 1969. You can think of it as a "cli text editor", or a line editor if you will.
What i mean by that is that you write a command/some text and hit enter. That's it. That's the entire UI.

##### Why did you make this?
Is this a practical editor? Probably not, but was it fun to make? Yes!

I made this for mainly two reasons:
- As a practice project so i can get some experience with lua and understand it better.
- Because i find the fact that you can edit text files through a complete cli interface very interesting, since you don't have anything like a cursor to move around or a status bar or anything of that sort.

##### How to use
Make sure you have `lua` installed. After that, go into the directory where `led.lua` is located and do,
```bash
lua led.lua
```

Alternatively, you could set up an alias if you want,
```bash
alias led='lua ~/path/to/file/led.lua'
```

##### Functions
- Open/Close files
- Make/Rename files
- Add/Change/Delete lines
- Check all the lines, or just the current line
- Move between lines
- Yank/Paste lines
- Undo
- Write/Quit files
- Clear screen (no cli program is complete without this)

**Limitations**
- Unlike ed, you can't work with a range of lines, this means you can't delete lines in bulk, etc.
- The undo command has a history of 1. If you do one command and then do another command, the first one is lost. Also, keep in mind that it only works for -> add/change/delete/pasting lines.
- Since undo is here, you'd probably expect redo to be a function too, but sadly it's not... as of now. I may implement it in the future.

##### Cheatsheet
[Cheatsheet](cheatsheet.md)

##### License

This project is licensed under the GPL 3.0 License - see the [License](LICENSE) file for details

---

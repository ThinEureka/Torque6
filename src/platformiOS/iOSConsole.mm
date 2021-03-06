//-----------------------------------------------------------------------------
// Copyright (c) 2013 GarageGames, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//-----------------------------------------------------------------------------

#include "platformiOS/platformiOS.h"
#include "platformiOS/iOSConsole.h"
#include "platform/event.h"
#include "game/gameInterface.h"
#include "platform/threads/thread.h"

#include <stdio.h>

// TODO: convert this to use ncurses.

iOSConsole *gConsole = NULL;

ConsoleFunction(enableWinConsole, void, 2, 2, "(bool enable)")
{
   if (gConsole)
      gConsole->enable(dAtob(argv[1]));
}

ConsoleFunction(enableDebugOutput, void, 2, 2, "(bool enable)")
{
	if (gConsole)
		gConsole->enableDebugOutput(dAtob(argv[1]));
}

static void iOSConsoleConsumer(ConsoleLogEntry::Level, const char *line)
{
   if (gConsole)
      gConsole->processConsoleLine(line);
}

static void iOSConsoleInputLoopThread(S32 *arg)
{
   if(!gConsole)
      return;
   gConsole->inputLoop();
}

void iOSConsole::create()
{
   gConsole = new iOSConsole();
}

void iOSConsole::destroy()
{
   if (gConsole)
      delete gConsole;
   gConsole = NULL;
}

void iOSConsole::enable(bool enabled)
{
   if (gConsole == NULL) return;
   
   consoleEnabled = enabled;
   if(consoleEnabled)
   {
      printf("Initializing Console...\n");
      new Thread((ThreadRunFunction)iOSConsoleInputLoopThread,0,true);
      printf("Console Initialized.\n");

      printf("%s", Con::getVariable("Con::Prompt"));
   }
   else
   {
      printf("Deactivating Console.");
   }
}

//%PUAP%
void iOSConsole::enableDebugOutput(bool enabled)
{
	if (gConsole == NULL) return;
	debugOutputEnabled = enabled;
}


bool iOSConsole::isEnabled()
{
   if ( !gConsole )
      return false;

   return gConsole->consoleEnabled;
}


iOSConsole::iOSConsole()
{
   consoleEnabled = false;
   clearInBuf();
   
   Con::addConsumer(iOSConsoleConsumer);
}

iOSConsole::~iOSConsole()
{
   Con::removeConsumer(iOSConsoleConsumer);
}

void iOSConsole::processConsoleLine(const char *consoleLine)
{
   if(consoleEnabled)
   {
         printf("%s\n", consoleLine);
   }
	//%PUAP%
	if(debugOutputEnabled)
	{
		printf("%s\n", consoleLine);
	}

}

void iOSConsole::clearInBuf()
{
   dMemset(inBuf, 0, MaxConsoleLineSize);
   inBufPos=0;
}

void iOSConsole::inputLoop()
{
   Con::printf("Console Input Thread Started");
   unsigned char c;
   while(consoleEnabled)
   {
      c = fgetc(stdin);
      if(c == '\n')
      {
         // exec the line
         dStrcpy(postEvent.data, inBuf);
         postEvent.size = ConsoleEventHeaderSize + dStrlen(inBuf) + 1;
         Con::printf("=> %s",postEvent.data);
         Game->postEvent(postEvent);
         // clear the buffer
         clearInBuf();
         // display the prompt. Note that we're using real printf, not Con::printf...
         printf("=> ");
      }
      else
      {
         // add it to the buffer.
         inBuf[inBufPos++] = c;
         // if we're full, clear & warn.
         if(inBufPos >= MaxConsoleLineSize-1)
         {
            clearInBuf();
            Con::warnf("Line to long, discarding the last 512 bytes...");
         }
      }
   }
   Con::printf("Console Input Thread Stopped");
}

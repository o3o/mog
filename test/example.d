import std.stdio;

public struct Status {
   bool ready;
   @property bool outOfOrder() { 
      return errorCode != 0;
   }
   bool automatic;
   int errorCode;
}

public interface IPrinter {
   Status getStatus();
   void clearBuffer();
   void print(string message, int size);
}

interface ICommand {
   string execute(string command);
   string executeSub(string command, string sub);
   void setSize(int size);
}

public class Printer: IPrinter {
   private  ICommand command;
   public this(ICommand command) {
      assert(command);
      this.command = command;
   }

   public Status getStatus() {
      return Status();
   }
   public void clearBuffer() {
      command.execute("^@");
   }
   public void print(string message, int size) {
      command.setSize(size);
      command.execute(message);
   }
}

unittest {
   import examplemock;
   auto command = new ICommandMock();
   auto printer = new Printer(command);
   printer.clearBuffer();
   command.executeReceived("^@");
}
unittest {
   import examplemock;
   auto command = new ICommandMock();
   auto printer = new Printer(command);
   printer.print("A", 5);
   command.setSizeReceived(5);
   command.executeReceivedAny();
   command.executeReceived("Ax");


}

import std.stdio;
import std.file; 
import std.json;
import std.string;

void generateClass(JSONValue member) {
   writeln("   class ", member["name"].str, "Mock: ", member["name"].str, " {");
   foreach (fun; member["functions"].array) {
      generateFunc(fun);
      generateRet(fun);
      generateReceived(fun);
      generateReceivedAny(fun);
      writeln();
   }   
   writeln("   }");
}
void generateFunc(JSONValue fun) {
   writeln("      ", "private bool ", fun["name"].str, "Done = false;");
   
   
   foreach (p; fun["parameters"].array) {
      writeln("      ", "private ", p["type"].str, " ", fun["name"].str, "_", p["name"].str, ";");
   }  



   writeln("      ", fun["returnType"].str, " " , fun["name"].str, "(", getArgs(fun), ") {");
   writeln("         ", fun["name"].str, "Done = true;");
   foreach (p; fun["parameters"].array) {
      writeln("         ", fun["name"].str, "_", p["name"].str, " = ", p["name"].str, ";");
   }

   
   if (fun["returnType"].str != "void") {
      writeln("         return ", fun["name"].str, "Ret;");
   }
   writeln("      }");
}

void generateRet(JSONValue fun) {
   if (fun["returnType"].str != "void") {
      writeln("      ", "private ", fun["returnType"].str, " ", fun["name"].str, "Ret;");   
      writeln("      void " , fun["name"].str, "Returns(", fun["returnType"].str, " value) {");
      writeln("         ", fun["name"].str, "Ret = value;");
      writeln("      }");
   }

}
void generateReceived(JSONValue fun) {
   writeln("      void ", fun["name"].str, "Received(", getArgs(fun), ") {");
   writeln("         ", fun["name"].str, "ReceivedAny();");
   foreach (p; fun["parameters"].array) {
      writeln("         assert(", p["name"].str, " == ", fun["name"].str, "_", p["name"].str, ", \"Expected to receive a call matching:", fun["name"].str,"\");");
   }
   
   writeln("      }");
}
void generateReceivedAny(JSONValue fun) {
   writeln("      void " , fun["name"].str, "ReceivedAny() {");
   writeln("         assert(", fun["name"].str, "Done, ",  "\"Expected to receive a call matching:", fun["name"].str, "(..)\");");
   writeln("      }");
}

string getArgs(JSONValue member) {
   string comma = "";
   string args = "";
   foreach (p; member["parameters"].array) {
      args ~= comma ~ p["type"].str ~ " " ~ p["name"].str;
      comma = ", ";
   }
   return args;
}


void main() {
   string content = readText("example.json");
   JSONValue root = parseJSON(content);

   writeln("import example;");
   writeln("version (mock) {");
   foreach (iface; root["interfaces"].array) {
      generateClass(iface);
   }
   writeln("}");
}

// See https://aka.ms/new-console-template for more information

string inputCsvPath = null;
string inputTemplatePath = null;
string outputScadPath = null;

for (int i = 0; i < args.Length; i++)
{
    switch (args[i])
    {
        case "--input-csv":
            inputCsvPath = args[i+1];
            break;
        case "--input-template":
            inputTemplatePath = args[i+1];
            break;
        case "--output-scad":
            outputScadPath = args[i+1];
            break;
    }
}

if (!File.Exists(inputCsvPath)) { Console.WriteLine($"Path not found: {inputCsvPath}"); Environment.Exit(1); }
if (!File.Exists(inputTemplatePath)) { Console.WriteLine($"Path not found: {inputTemplatePath}"); Environment.Exit(1); }

Console.WriteLine("Copying template scad to working scad...");
File.Copy(inputTemplatePath, outputScadPath, true);

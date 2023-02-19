// See https://aka.ms/new-console-template for more information

var MAX_WIDTH = 11;
var MAX_HEIGHT = 9;

var KEY_DESIGN="{{DESIGN}}";
var KEY_DESIGN_WIDTH="{{DESIGN_WIDTH}}";
var KEY_DESIGN_HEIGHT="{{DESIGN_HEIGHT}}";
var KEY_MODE="{{MODE}}";

string inputCsvPath = null;
string inputTemplatePath = null;
string outputScadPath = null;
string inputVarsPath = null;
string mode = "0";

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
        case "--input-vars":
            inputVarsPath = args[i+1];
            break;
        case "--output-scad":
            outputScadPath = args[i+1];
            break;
    }
}

// exit if files aren't available
if (!File.Exists(inputCsvPath)) { Console.WriteLine($"[ERROR] Crossword CSV path not found: {inputCsvPath}"); Environment.Exit(1); }
if (!File.Exists(inputTemplatePath)) { Console.WriteLine($"[ERROR] Template path not found: {inputTemplatePath}"); Environment.Exit(1); }
if (!File.Exists(inputVarsPath)) { Console.WriteLine($"[ERROR] Variables path not found: {inputVarsPath}"); Environment.Exit(1); }
if (outputScadPath == null) { Console.WriteLine($"[ERROR] Output path not defined."); Environment.Exit(1); }

// read template, CSV, and variable substitutions
var template = File.ReadAllText(inputTemplatePath);
var csv = File.ReadAllLines(inputCsvPath).Select(r => r.Split(',').Select(c => c.Trim('"').Trim()));
var variableSubstitutions = File.ReadAllLines(inputVarsPath).Select(r => r.Split(',').Select(c => c.Trim('"').Trim()));

// errors in CSV
if (csv.Any(r => r.Any(cell => cell.Length > 1))) { Console.WriteLine($"[ERROR] Found a cell that contains more than 1 character."); Environment.Exit(1); }

// warnings about CSV
if (csv.Any(r => r.Count() > MAX_WIDTH)) { Console.WriteLine($"[WARNING] Found a row longer than {MAX_WIDTH}."); }
if (csv.Count() > MAX_HEIGHT) { Console.WriteLine($"[WARNING] Found more than {MAX_HEIGHT} rows."); }

// build the design array and design string
Console.WriteLine("Preparing source...");
var designArray = new List<string>();
foreach (var row in csv)
{
    var displayStr = string.Join("", row.Select(r => string.IsNullOrWhiteSpace(r) ? "." : r));
    Console.WriteLine($"... {displayStr}");

    var designArrayRow = string.Join(",", row.Select(r => string.IsNullOrWhiteSpace(r) ? "0" : r.All(char.IsUpper) ? "2" : "1"));
    designArray.Add($"[{designArrayRow}]");
}
var design = $"[{string.Join(",", designArray)}]";
Console.WriteLine("... complete.");
Console.WriteLine();

// substitutions for the template
var substitutions = new Dictionary<string, string>()
{
    { KEY_DESIGN, design },
    { KEY_DESIGN_WIDTH, csv.Max(row => row.Count()).ToString() },
    { KEY_DESIGN_HEIGHT, csv.Count().ToString() }
};

// append the variable substitutions from their file
foreach (var row in variableSubstitutions)
{
    substitutions.Add("{{"+row.ElementAt(0)+"}}", row.ElementAt(1));
}

Console.WriteLine("Generating SCAD from template...");
var scad = new string(template);
foreach (var substitution in substitutions)
{
    Console.WriteLine($"... substitution: {substitution.Key}");
    scad = scad.Replace(substitution.Key, substitution.Value);
}
Console.WriteLine();

Console.WriteLine($"Writing to: {outputScadPath}...");
File.WriteAllText(outputScadPath, scad);
Console.WriteLine($"... complete.");
Console.WriteLine();

// Console.WriteLine("Copying template scad to working scad...");
// File.Copy(inputTemplatePath, outputScadPath, true);

// See https://aka.ms/new-console-template for more information

var MAX_WIDTH = 11;
var MAX_HEIGHT = 9;

var KEY_DESIGN="{{DESIGN}}";
var KEY_DESIGN_WIDTH="{{DESIGN_WIDTH}}";
var KEY_DESIGN_HEIGHT="{{DESIGN_HEIGHT}}";

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

var template = File.ReadAllText(inputTemplatePath);
var csv = File.ReadAllLines(inputCsvPath).Select(r => r.Split(',').Select(c => c.Trim('"').Trim()));

if (csv.Any(r => r.Any(cell => cell.Length > 1))) { Console.WriteLine($"Found a cell that contains more than 1 character."); Environment.Exit(1); }
if (csv.Any(r => r.Count() > MAX_WIDTH)) { Console.WriteLine($"Found a row longer than {MAX_WIDTH}."); Environment.Exit(1); }
if (csv.Count() > MAX_HEIGHT) { Console.WriteLine($"Found more than {MAX_HEIGHT} rows."); Environment.Exit(1); }

var designArray = new List<string>();
foreach (var row in csv)
{
    var displayStr = string.Join("", row.Select(r => string.IsNullOrWhiteSpace(r) ? "." : r));
    Console.WriteLine(displayStr);

    var designArrayRow = string.Join(",", row.Select(r => string.IsNullOrWhiteSpace(r) ? "0" : r.All(char.IsUpper) ? "2" : "1"));
    designArray.Add($"[{designArrayRow}]");
}

var design = $"[{string.Join(",", designArray)}]";
// Console.WriteLine(design);

var substitutions = new Dictionary<string, string>()
{
    { KEY_DESIGN, design },
    { KEY_DESIGN_WIDTH, MAX_WIDTH.ToString() },
    { KEY_DESIGN_HEIGHT, MAX_HEIGHT.ToString() }
};

Console.WriteLine("Generating SCAD from template...");
var scad = new string(template);
foreach (var substitution in substitutions)
{
    scad = scad.Replace(substitution.Key, substitution.Value);
}

Console.WriteLine($"Writing to output file: {outputScadPath}");
File.WriteAllText(outputScadPath, scad);

// Console.WriteLine("Copying template scad to working scad...");
// File.Copy(inputTemplatePath, outputScadPath, true);

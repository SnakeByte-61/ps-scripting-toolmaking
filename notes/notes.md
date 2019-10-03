# PC Scripting and Toolmaking

## Part 2: Professional Grade Toolmaking

### Going Deeper with Parameters

Import notes from Main PC (if any)

#### Positional Parameters

Set by using the `Position=n` Decorator, as below:

```PowerShell
param(
  [Parameter(Position=1)]
  [string[]]$Position1
)
```

Jeff and Don suggest avoiding Positional Parameters unless they will bring some real benefit that can't be seen
with standard Parameters.

Powershell will automatically position parameters in the order in which you specify them in the `param()` block.

#### Parameter Sets

The most appropriate use of Sets is to define distinct parameters and prevent them from being used with others
that might cause conflict. For example, having a parameter which accepts a txt file as a source of computer names
and a separate one which allows the user to specify the computer names in the console. These would not work at the
same time, so are a good use case for Parameter Sets.

Parameters with no Parameter set name attribute are made available to all Parameter Sets.

PowerShell will attempt to determine the DefaultParameterSetName automatically, unless you specify it in
`cmdletbinding` like so:

```Powershell
[CmdletBinding(DefaultParameterSetName="whatever")]
```

#### Validation

Always worth doing. See examples and use them. Validate Sets, for example, like `'C:','D:','E:'` will allow the user
to step through the valid options with tab.

### Dynamic Parameters

Something to use _rarely_, in situations where the same goal cannot be achieved using standard parameters or 
parameter sets.

Automatic Variable Example:

$this - In a script block that defines a script property or script method, the $This variable refers to the object that is being extended.

// -----------------------------  Imports ---------------------------------- // 
import 'dart:async'; 
import 'dart:collection'; 
import '../command_runner.dart';

// -----------------------------  Enum/Data ---------------------------------- //
// A flag is a boolean option that does not take a value, e.g. --verbose
// Option that takes a value, e.g. --output=<file.txt>  
// --------------------------------------------------------------------------- //
enum OptionType {
  flag,           
  option,         
}

// -----------------------------  Abstract Classes ---------------------------------- //
// Arguments:- 
// - name: the name of the argument
// - usage: a string that describes how to use the argument
// - help: a string that describes the argument (optional)
// - defaultValue: the default value of the argument (optional)
// - valueHelp: a string that describes the value of the argument (optional)
// ---------------------------------------------------------------------------------- //
abstract class Arguments {
  // getter declarations 
  String get name;    // name of the argument
  String get usage;   // string how to use the argument

  // nullable getters declarations
  String? get help;           // description of the argument
  Object? get defaultValue;   // default value of the argument
  String? get valueHelp;      // expected value description of the argument
}

abstract class Command extends Arguments {
  @override
  String get name;

  String get description;

  bool get requiresArgument => false;

  late CommandRunner runner;  // cannot be null

  @override
  String? help;

  @override
  String? defaultValue;

  @override
  String? valueHelp;

  // prefix underscore to indicate that this is a private variable that should not be accessed outside of this class
  final List<Option> _options = [];

  // restrict direct access to options
  UnmodifiableSetView<Option> get options =>
      UnmodifiableSetView(_options.toSet());

  // internal functions to add values to _options 
  void addFlag(String name, {String? help, String? abbr, String? valueHelp}) {
    _options.add(
      Option(
        name,
        help: help,
        abbr: abbr,
        defaultValue: false,
        valueHelp: valueHelp,
        type: OptionType.flag,
      ),
    );
  }

  void addOption(
    String name, {
    String? help,
    String? abbr,
    String? defaultValue,
    String? valueHelp,
  }) {
    _options.add(
      Option(
        name,
        help: help,
        abbr: abbr,
        defaultValue: defaultValue,
        valueHelp: valueHelp,
        type: OptionType.option,
      ),
    );
  }

  // Synchronous or asynchronous function that runs the command logic with the given arguments.
  FutureOr<Object?> run(ArgResults args);

  @override
  String get usage {
    return '$name:  $description';

  }
}

// -----------------------------  Implementation ---------------------------------- //
// Represents command-line options e.g. --verbose or --output=<file.txt> 
// -------------------------------------------------------------------------------- //
class Option extends Arguments {
  // constructor with required and optional parameters
  Option(
    this.name,  // positionally required parameter for the name of the option
    {           // named parameters for the other properties of the option
      required this.type,
      this.help,
      this.abbr,
      this.defaultValue,
      this.valueHelp,
    }
  );
  
  // return var for getter declarations
  @override
  final String name;

  final OptionType type;

  @override
  final String? help;

  final String? abbr;

  @override
  final Object? defaultValue;

  @override
  final String? valueHelp;

  @override
  String get usage {
    if (abbr != null) 
    {
      return '-$abbr,--$name: $help';
    }
    return '--$name: $help';
  }

}

class ArgResults {
  Command? command;
  String? commandArg;
  Map<Option, Object?> options = {};

  // Returns true if the flag exists.
  bool flag(String name) {
    // Only check flags, because we're sure that flags are booleans.
    for (var option in options.keys.where(
      (option) => option.type == OptionType.flag,
    )) {
      if (option.name == name) {
        return options[option] as bool;
      }
    }
    return false;
  }

  bool hasOption(String name) {
    return options.keys.any((option) => option.name == name);
  }

  ({Option option, Object? input}) getOption(String name) {
    var mapEntry = options.entries.firstWhere(
      (entry) => entry.key.name == name || entry.key.abbr == name,
    );

    return (option: mapEntry.key, input: mapEntry.value);
  }
}
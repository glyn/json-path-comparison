Results do not match other implementations

The following queries provide results that do not match those of other implementations of JSONPath
(compare https://cburgmer.github.io/json-path-comparison/):

- [ ] `$[1:3]`
  Input:
  ```
  {
    ":": 42,
    "more": "string",
    "a": 1,
    "b": 2,
    "c": 3
  }
  ```
  Expected output:
  ```
  []
  ```
  Error:
  ```
  init terminating in do_boot (not_implemented)
  
  Crash dump is being written to: /dev/null...done
  {"init terminating in do_boot",not_implemented}
  ```

- [ ] `$[::]`
  Input:
  ```
  [
    "first",
    "second"
  ]
  ```
  Expected output:
  ```
  ["first", "second"]
  ```
  Error:
  ```
  init terminating in do_boot ({badmatch,{error,{1,ejsonpath_parse,syntax error before: ':'}}})
  
  Crash dump is being written to: /dev/null...done
  {"init terminating in do_boot",{badmatch,{error,{1,ejsonpath_parse,["syntax error before: ","':'"]}}}}
  ```

- [ ] `$[1:3:]`
  Input:
  ```
  [
    "first",
    "second",
    "third",
    "forth",
    "fifth"
  ]
  ```
  Expected output:
  ```
  ["second", "third"]
  ```
  Error:
  ```
  init terminating in do_boot ({badmatch,{error,{1,ejsonpath_parse,syntax error before: ']'}}})
  
  Crash dump is being written to: /dev/null...done
  {"init terminating in do_boot",{badmatch,{error,{1,ejsonpath_parse,["syntax error before: ","']'"]}}}}
  ```

- [ ] `$[::2]`
  Input:
  ```
  [
    "first",
    "second",
    "third",
    "forth",
    "fifth"
  ]
  ```
  Expected output:
  ```
  ["first", "third", "fifth"]
  ```
  Error:
  ```
  init terminating in do_boot ({badmatch,{error,{1,ejsonpath_parse,syntax error before: ':'}}})
  
  Crash dump is being written to: /dev/null...done
  {"init terminating in do_boot",{badmatch,{error,{1,ejsonpath_parse,["syntax error before: ","':'"]}}}}
  ```

- [ ] `$..[0]`
  Input:
  ```
  [
    "first",
    {
      "key": [
        "first nested",
        {
          "more": [
            {
              "nested": [
                "deepest",
                "second"
              ]
            },
            [
              "more",
              "values"
            ]
          ]
        }
      ]
    }
  ]
  ```
  Expected output (in any order as no consensus on ordering exists):
  ```
  ["deepest", "first nested", "first", "more", {"nested": ["deepest", "second"]}]
  ```
  Error:
  ```
  init terminating in do_boot ({badmatch,{error,{1,ejsonpath_parse,syntax error before: '['}}})
  
  Crash dump is being written to: /dev/null...done
  {"init terminating in do_boot",{badmatch,{error,{1,ejsonpath_parse,["syntax error before: ","'['"]}}}}
  ```

- [ ] `$..[*]`
  Input:
  ```
  {
    "key": "value",
    "another key": {
      "complex": "string",
      "primitives": [
        0,
        1
      ]
    }
  }
  ```
  Expected output (in any order as no consensus on ordering exists):
  ```
  ["string", "value", 0, 1, [0, 1], {"complex": "string", "primitives": [0, 1]}]
  ```
  Error:
  ```
  init terminating in do_boot ({badmatch,{error,{1,ejsonpath_parse,syntax error before: '['}}})
  
  Crash dump is being written to: /dev/null...done
  {"init terminating in do_boot",{badmatch,{error,{1,ejsonpath_parse,["syntax error before: ","'['"]}}}}
  ```

- [ ] `$.key-dash`
  Input:
  ```
  {
    "key-dash": "value"
  }
  ```
  Expected output:
  ```
  ["value"]
  ```
  Error:
  ```
  init terminating in do_boot ({badmatch,{error,{1,ejsonpath_parse,syntax error before: '-'}}})
  
  Crash dump is being written to: /dev/null...done
  {"init terminating in do_boot",{badmatch,{error,{1,ejsonpath_parse,["syntax error before: ","'-'"]}}}}
  ```

- [ ] `$.屬性`
  Input:
  ```
  {
    "\u5c6c\u6027": "value"
  }
  ```
  Expected output:
  ```
  ["value"]
  ```
  Error:
  ```
  init terminating in do_boot (Timeout)
  
  Crash dump is being written to: /dev/null...done
  {"init terminating in do_boot","Timeout"}
  ```

- [ ] `$.2`
  Input:
  ```
  {
    "a": "first",
    "2": "second",
    "b": "third"
  }
  ```
  Expected output:
  ```
  ["second"]
  ```
  Error:
  ```
  init terminating in do_boot ({badmatch,{error,{1,ejsonpath_parse,syntax error before: 2}}})
  
  Crash dump is being written to: /dev/null...done
  {"init terminating in do_boot",{badmatch,{error,{1,ejsonpath_parse,["syntax error before: ",["2"]]}}}}
  ```


For reference, the output was generated by the program in https://github.com/cburgmer/json-path-comparison/tree/master/implementations/Erlang_ejsonpath.

# Frequenty asked questions

Please report bugs or suggestions on how the program / user interface / manual could be improved or made more user friendly to John.Hickey@roslin.ed.ac.uk.

\etocsetnexttocdepth{2}
\localtableofcontents

## Input

### My genotypes are in multiple files

The R-package `Siccuracy` (<https://github.com/stefanedwards/Siccuracy>) has been developed for
working the genotype files for AlphaImpute.


## Error messages

### `The system cannot find the file specified.`

This error occures in Windows, when AlphaImpute attempts to remove previous output directories
(`Phasing`, `Miscellaneous`, and `Results`). 
It results in the following error message, right after the AlphaImpute 'logo'.

```
The system cannot find the file specified.
The system cannot find the file specified.
The system cannot find the file specified.
```

### `OMP: Error #34`

I am receiving the error
```
OMP: Error #34: System unable to allocate necessary resources for OMP thread:
OMP: System error #11: Resource temporarily unavailable
OMP: Hint: Try decreasing the value of OMP_NUM_THREADS.
forrtl: error (76): Abort trap signal
```

**Answer:**

Use the setting `ParallelProcessors ,1`. Use values larger than 1 if you have more cores to use.


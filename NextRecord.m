function ubdstruct = NextRecord(ubdstruct)
% NextRecord(IndexIn) Increments the record counter in the indexed FORTRAN
%   unformatted data file stored in the structure ubdstruct.
%   
%   See the header of ReadFORTRANBinary for an example of use.

% Daniel Warren
% Department of Oncology
% University of Oxford
%
% v1.2 28/07/15 - relicensed under BSD license

ubdstruct.RecordCounter = ubdstruct.RecordCounter+1;
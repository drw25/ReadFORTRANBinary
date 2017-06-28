function data = ReadRecord(ubdstruct,range,type)
% ReadRecord(ubdstruct, range, type) Returns the content of the current
%   record in the indexed FORTRAN unformatted data file stored in the
%   structure ubdstruct.  By default bytes are returned in uint8 format.
%   A subset of the bytes can be selected by the optional parameter range,
%   and the output be optionally cast into the datatype defined by type.
%
%   The current record is stored in ubdstruct.RecordCounter, and may be
%   incremented with the function NextRecord.
%
%   eg.
%       a = ReadRecord(ubdstruct,1:8);
%       b = typecast(a,'double');
%   a is a uint8 representation of the first 8 bytes of the current record
%   in ubdstruct. b is the double precision floating point value
%   corresponding to those bytes. The same result can be achieved with
%   b = ReadRecord(ubdstuct,1:8,'double');
%
%   See the header of ReadFORTRANBinary for a more detailed example.

% v1.2 28/07/15 - added option to cast to a specified datatype, relicensed
%                 under BSD license
%
% Daniel Warren
% Department of Oncology
% University of Oxford

if ~exist('range','var')
data = ubdstruct.RecordData{ubdstruct.RecordCounter};
else
    data = ubdstruct.RecordData{ubdstruct.RecordCounter}(range);
end

if exist('type','var')
    data = typecast(data,type);
end

end
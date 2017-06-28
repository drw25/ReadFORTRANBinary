function data = ReadRecord_disk(ubdstruct,range,type)
% ReadRecord_disk(ubdstruct, range, type) is identical to ReadRecord,
%   except it takes the indexed structure for ReadFORTRANBinary_disk, which
%   includes an open file handle, and reads record data from disk instead
%   of memory. The file in ubdstruct.FileHandle will not be closed, so
%   remember to do this at the end of your program.
%
%   See the headers of ReadRecord and  ReadFORTRANBinary for example of
%   use.

% v1.2 28/07/15 - relicensed under BSD license
%
% Daniel Warren
% Department of Oncology
% University of Oxford

if ~exist('range','var')
    range = 1:ubdstruct.RecordLengths(ubdstruct.RecordCounter);
end

fseek(ubdstruct.FileHandle,ubdstruct.RecordStarts(ubdstruct.RecordCounter)+min(range(:))-1,'bof');
data = fread(ubdstruct.FileHandle,max(range(:))-min(range(:))+1,'*ubit8');
range = range+1-min(range(:));
data = data(range);

if exist('type','var')
    data = typecast(data,type);
end

end
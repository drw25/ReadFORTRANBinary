function ubdstruct = ReadFORTRANBinary_disk(filename)
% ReadFORTRANBinary_disk(filename) is identical to ReadFORTRANBinary,
%   except that it does not store record data in memory. It can be used in
%   conjuction with ReadRecord_disk to overcome memory limitations when
%   reading in large files. Use as ReadFORTRANBinary. The file in
%   ubdstruct.FileHandle will not be closed, so remember to do this at the
%   end of your program e.g. fclose(ubdstruct.FileHandle); (Alternatively
%   one could close the file at the end of this function and then reopen it
%   in ReadRecord_disk using the filename stored in ubdstruct.FileName)

% v1.2 28/07/15 - relicensed under BSD license
%
% Daniel Warren
% Department of Oncology
% University of Oxford

h=waitbar(0,'Indexing FORTRAN unformatted data file...');
fid=fopen(filename,'r','n');
fseek(fid,0,'eof');
filesize = ftell(fid);
maxrecords = ceil(filesize/8); % to preallocate output - actual records may be fewer
frewind(fid);

ubdstruct.RecordLengths = zeros(maxrecords,1,'uint32');
ubdstruct.RecordStarts = zeros(maxrecords,1,'uint32');
ubdstruct.FileHandle = fid;

i = 0;
endoffile=0;
while ~endoffile
    waitbar(ftell(fid)/filesize,h,'Indexing FORTRAN unformatted data file...');
    i=i+1;
    RecordLength = fread(fid,1,'*uint32');
    if ~isempty(RecordLength)
    ubdstruct.RecordLengths(i) = RecordLength;
    ubdstruct.RecordStarts(i) = ftell(fid);
    fseek(fid,RecordLength+4,'cof');  % skip record data and footer
    else
    endoffile = 1;
    end
end

ubdstruct.RecordLengths((i+1):end)=[];
ubdstruct.RecordStarts((i+1):end)=[];
ubdstruct.RecordCounter=1;
ubdstruct.FileName = filename;

close(h);

end
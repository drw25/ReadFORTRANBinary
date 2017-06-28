function ubdstruct = ReadFORTRANBinary(filename)
% ReadFORTRANBinary(filename) Indexes and stores the data from a FORTRAN
%   unformatted binary data file in a structure and then returns that
%   structure.
%
%   This version stores all record data in memory so may not be appropriate
%   for very large input files. In this case use ReadFORTRANBinary_disk.
%
%   ReadFORTRANBinary may be useful for porting FORTRAN code to MATLAB:
%    - First replace the FORTRAN OPEN statement by this indexing function
%        e.g. open(30,file='indata',form='unformatted',status='old')
%                becomes
%             ubdstruct30 = ReadFORTRANBinary('indata');
%   -  Subsequent READ statements can then be replaced by ReadRecord
%      followed by NextRecord. The latter increments the current record
%      counter stored in the ubdstruct.
%        e.g. read(30)int1,flt1,int2
%                becomes
%             int1 = ReadRecord(ubdstruct30,1:4,'uint32);
%             flt1 = ReadRecord(ubdstruct30,5:12,'double');
%             int2 = ReadRecord(ubdstruct30,13:17,'uint32');
%             ubdstruct30 = NextRecord(ubdstruct30);
%                assuming the input file was written with 32-bit integers
%                and 64-bit floats (double precision). Endian conversion
%                could be performed by flipping the requested bytes.

% v1.1 25/07/11 - significantly reduced memory usage, speed improvements
% v1.2 28/07/15 - further reduced memory usage, relicensed under BSD license
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
ubdstruct.RecordData = cell(maxrecords,1);

i = 0;
endoffile=0;
while ~endoffile
    waitbar(ftell(fid)/filesize,h,'Indexing FORTRAN unformatted data file...');
    i=i+1;
    RecordLength = fread(fid,1,'*uint32');
    if ~isempty(RecordLength)
    ubdstruct.RecordLengths(i) = RecordLength;
    ubdstruct.RecordStarts(i) = ftell(fid);
    ubdstruct.RecordData{i} = fread(fid,ubdstruct.RecordLengths(i),'*ubit8');
    fseek(fid,4,'cof');  % skip record footer
    else
    endoffile = 1;
    end
end

fclose(fid);

ubdstruct.RecordLengths((i+1):end)=[];
ubdstruct.RecordStarts((i+1):end)=[];
ubdstruct.RecordData((i+1):end)=[];
ubdstruct.RecordCounter=1;
ubdstruct.FileName = filename;

close(h);

end
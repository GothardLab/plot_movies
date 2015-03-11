function [ cipherName ] = cipherName( realName )
%CYPHERNAMES Summary of this function goes here
%   Detailed explanation goes here

    nameDouble = double(realName);
    nameBase36 = dec2base(nameDouble, 36);
    movieNameReshape = reshape(nameBase36,1,size(nameBase36,1)*size(nameBase36,2));
    originalBase36 = reshape(movieNameReshape,size(movieNameReshape,2)/2,2);
    
    cipherName = movieNameReshape;

end


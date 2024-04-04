function result = caesar(text, key)
    len = length(text);
    result = zeros(len,1);
    if key == 0
        result = text;
    else
        text = [text(1,:),text(1,:)];
        for i = 1:len
            result(i,1) = text(1,i + key);
        end
    end
    clear len
end
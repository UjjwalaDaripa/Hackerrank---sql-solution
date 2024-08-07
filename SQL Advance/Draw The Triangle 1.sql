DECLARE @cnt INT = 20; 
WHILE @cnt > 0 
    BEGIN select replicate("* ",@cnt); 
        SET @cnt = @cnt - 1; 
END;

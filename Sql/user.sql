CREATE LOGIN yasmin WITH PASSWORD = 'YourStrongPasswordHere'; 
CREATE USER yasmin FOR LOGIN yasmin;


USE GlobalGourmet;
ALTER ROLE db_owner ADD MEMBER yasmin;
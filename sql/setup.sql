create or replace procedure openfire.setup_auth (@tablename text)
begin
    
    insert into ofproperty (name,propValue) 
        on existing update 
        VALUES ('provider.user.className','org.jivesoftware.openfire.user.JDBCUserProvider')
    ;
    
    insert into ofproperty (name,propValue) 
        on existing update 
        VALUES ('jdbcUserProvider.loadUserSQL',string('SELECT username,email FROM ', @tablename, ' WHERE username=?'))
    ;
    
    insert into ofproperty (name,propValue) 
        on existing update 
        VALUES ('jdbcUserProvider.userCountSQL',string('SELECT COUNT(*) FROM ', @tablename))
    ;
    
    insert into ofproperty (name,propValue) 
        on existing update 
        VALUES ('jdbcUserProvider.allUsersSQL',string('SELECT username FROM ', @tablename))
    ;
    
    insert into ofproperty (name,propValue) 
        on existing update 
        VALUES ('jdbcUserProvider.searchSQL',string('SELECT username FROM ', @tablename, ' WHERE'))
    ;
    
    insert into ofproperty (name,propValue) 
        on existing update 
        VALUES ('usernameField','username')
    ;
    
    insert into ofproperty (name,propValue) 
        on existing update 
        VALUES ('nameField','username')
    ;
    
    insert into ofproperty (name,propValue) 
        on existing update 
        VALUES ('emailField','email')
    ;
    
end;
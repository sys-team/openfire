create or replace procedure oprenfire.delete_auth ()
begin
 delete from openfire.ofproperty
    where name like 'jdbc%'
        or name like 'provider.user.className'
        or name like 'provider.auth.className'
        or name like 'usernameField'
        or name like 'nameField'
        or name like 'emailField';
end;
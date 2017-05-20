# capstone-394
Repository for all CSC 394 - Group 1 files

* Please read ALL issues and commit messages!!!

* Push code out here you are working on even if you are not done! This will help us track progress better.

* To add a role type "rails console" in terminal. Find user by id, "user = User.find(1)" <-- Number being the id number of user. Once that user is assigned to the variable, you can do "user.admin!" ,"user.faculty!", "user.student!" (note: registered users are automatically assigned as student". To test the role was properly assigned, you can do "user.admin?", "user.faculty?", "user.student?".

* All available method examples for roles: 

   User.roles # list all roles
   
   user.student! # make a student user
   
   user.student? # => true # query if the user is a student
   
   user.role # => "student" # find out the user’s role
   
   @users = User.student # obtain an array of all users who are students
   
   user.role = 'foo' # ArgumentError: 'foo' is not a valid, we can’t set invalid roles

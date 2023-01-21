import React from "react";
import SessionManager from "../sessions/SessionManager";
import { Link } from "react-router-dom";
import { selectIsLoggedIn } from "../sessions/sessionSlice";
import { useSelector } from "react-redux";
import Logout from "../sessions/Logout.js";
function NavBar() {
  const isLoggedIn = useSelector(selectIsLoggedIn);

  return (
    <div>
      <nav>
        <Link to="/home">Home</Link>
        <Link to="/posts">Posts</Link>
        <Link to="/groups">Groups</Link>
      </nav>
      {isLoggedIn ? <Logout /> : <SessionManager />}
    </div>
  );
}

export default NavBar;

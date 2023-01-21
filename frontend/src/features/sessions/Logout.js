import React from "react";
import { useDispatch } from "react-redux";
import { logoutUserAsync } from "./sessionSlice";

function SessionManager() {
  const dispatch = useDispatch();

  function logout() {
    dispatch(logoutUserAsync());
  }

  return (
    <div>
      <button onClick={logout}>Log out</button>
    </div>
  );
}

export default SessionManager;

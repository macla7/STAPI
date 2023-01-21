import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { logoutUserAsync } from "./sessionSlice";
import {
  selectAuthToken,
  selectUserEmail,
  selectUserId,
  selectUserAvatarUrl,
  selectIsLoggedIn,
} from "./sessionSlice";
import Register from "./Register";
import Login from "./Login";

function SessionManager() {
  const authToken = useSelector(selectAuthToken);
  const userEmail = useSelector(selectUserEmail);
  const userId = useSelector(selectUserId);
  const userAvatarUrl = useSelector(selectUserAvatarUrl);
  const isLoggedIn = useSelector(selectIsLoggedIn);
  const dispatch = useDispatch();

  function logout() {
    dispatch(logoutUserAsync());
  }

  return (
    <div>
      <div>
        <p>{authToken ? "got token" : "no token"}</p>
        <p>{userEmail}</p>
        <p>{userId}</p>
        <img src={userAvatarUrl} alt="avatar" />
      </div>
      <h3>Register</h3>
      <Register />
      <h3>Login</h3>
      <Login />
    </div>
  );
}

export default SessionManager;

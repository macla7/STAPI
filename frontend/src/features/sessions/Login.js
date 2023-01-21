import React, { useState } from "react";
import { useDispatch } from "react-redux";
import { loginUserAsync } from "./sessionSlice";

function Login() {
  const dispatch = useDispatch();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  function handleLogin(e) {
    e.preventDefault();

    const registerUserDetails = {
      email: e.target.email.value,
      password: e.target.password.value,
    };

    dispatch(loginUserAsync(registerUserDetails));
  }

  return (
    <div>
      <form onSubmit={(e) => handleLogin(e)}>
        <label>
          Email{" "}
          <input
            type="email"
            id="email"
            name="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          ></input>
        </label>

        <label>
          Password
          <input
            type="password"
            id="password"
            name="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          ></input>
        </label>

        <input type="submit" value="Login" />
      </form>
    </div>
  );
}

export default Login;

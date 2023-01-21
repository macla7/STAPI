const API_URL = "http://localhost:3000/api/v1";
const BASE_URL = "http://localhost:3000";

export async function registerUser(payload) {
  return fetch(`${API_URL}/users`, {
    method: "POST",
    body: payload,
  })
    .then(async (response) => response.json())
    .catch((error) => {
      console.log("Error: ", error);
      // Not a longer term proper soloution
      return {};
    });
}

export async function loginUser(payload) {
  return fetch(`${API_URL}/users/session-data`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(payload),
  })
    .then((response) => response.json())
    .catch((error) => {
      console.log("Error: ", error);
      // Not a longer term proper soloution
      return {};
    });
}

export async function logoutUser(payload) {
  const auth_token = payload.token;

  return fetch(`${API_URL}/oauth/revoke.json`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: auth_token,
    },
    body: JSON.stringify(payload),
  })
    .then((response) => response.json())
    .catch((error) => {
      console.log("Error: ", error);
      // Not a longer term proper soloution
      return {};
    });
}

export async function loginUserWithToken(payload) {
  return fetch(`${API_URL}/users/session-data`, {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${payload.auth_token}`,
    },
  })
    .then((response) => response.json())
    .catch((error) => {
      console.log("Error: ", error);
      // Not a longer term proper soloution
      return {};
    });
}

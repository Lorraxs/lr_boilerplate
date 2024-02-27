import { createSlice } from '@reduxjs/toolkit';

interface InitialState {
  show: boolean;
}

const initialState: InitialState = {
  show: false,
};

const mainSlice = createSlice({
  name: 'main',
  initialState,
  reducers: {
    setShow(state, action) {
      state.show = action.payload;
    },
  },
});

export default mainSlice;

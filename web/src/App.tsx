import React from 'react';
import { Provider, useSelector } from 'react-redux';
import { RootState, store } from './store';
import { ToastContainer } from 'react-toastify';
import { Box } from 'lr-components';
import { NextUIProvider } from '@nextui-org/react';

function App() {
  const show = useSelector((state: RootState) => state.state.show);
  return (
    show && (
      <NextUIProvider>
        <Provider store={store}>
          <Box
            width={'100%'}
            height={'100%'}
            display='flex'
            justifyContent='center'
            alignItems='center'
            className='prose'
            pointerEvents='none'
          ></Box>

          <ToastContainer pauseOnFocusLoss={false} hideProgressBar={true} />
        </Provider>
      </NextUIProvider>
    )
  );
}

export default App;

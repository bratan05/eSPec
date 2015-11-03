      PROGRAM CHECK2DCT
      implicit none
      INTEGER I,J,K,NP(3)
      REAL*8 SHM(3),US(50000),AU(50000),VPOT(50000),ANS,A
      REAL*8 X,XI,XF,Y,YI,YF,STEPX,STEPY,DIFF,B
      REAL*8 DXX(50000),DYY(50000),DXY(50000)
      REAL*8 NFXX,NFYY,NFXY,FXX,FYY,FXY,GAUSS
      REAL*8 NUMDERIV,NANS

      write(*,*) "lol"
      NP(1)=50
      NP(2)=50

      A = 1.0D+0
      B = 1.5D+0

      XI=-0.5D+1
      XF=0.5D+1
      YI=-0.3D+1
      YF=0.3D+1

      STEPX = (XF - XI)/(NP(1) -1)
      STEPY = (YF - YI)/(NP(2) -1)
      SHM(1) = -1.0/(12*STEPX**2)!0.0D+0!1.0/(12*STEPX**2)
      SHM(2) = -1.0/(12*STEPY**2)!0.0D+0!1.0/(12*STEPY**2)
      SHM(3) = -1.0/(48*STEPX*STEPY)
      write(*,*) "lol 2"
      DO I=1,NP(1),1
         X = XI + (I-1)*STEPX
         DO J=1,NP(2),1
            Y = YI + (J-1)*STEPY
            K = I + (J-1)*NP(1)
            US(K) = GAUSS(X,Y,0) !A*DEXP(-B*x**2)*DEXP(-B*y**2)
            VPOT(K) = 0.0D+0
         ENDDO
      ENDDO
      
      write(*,*) "lol 3"

cccccccccccccccccccccccccccccc

      !TOTAL DXX + DYY + DXY  
      SHM(1) = -1.0/(12*STEPX**2)!0.0D+0!1.0/(12*STEPX**2)
      SHM(2) = -1.0/(12*STEPY**2)!0.0D+0!1.0/(12*STEPY**2)
      SHM(3) = -1.0/(48*STEPX*STEPY)
      CALL AU_2DCT(NP, SHM, VPOT, US, AU)


      STOP
      END


      FUNCTION GAUSS(X,Y,I)
      implicit none
      INTEGER I
      REAL*8 A,B,X,Y,GAUSS
      
      A = 1.0D+0
      B = 1.5D+0

      IF(I.EQ.0)THEN
         GAUSS = A*DEXP(-B*x**2)*DEXP(-B*y**2)
      ELSEIF(I.EQ.1)THEN !FXX
         GAUSS = (4*X*X*B -2)*B*A*DEXP(-B*x**2 - B*y**2)
      ELSEIF(I.EQ.2)THEN !FYY
         GAUSS = (4*Y*Y*B -2)*B*A*DEXP(-B*x**2 - B*y**2)
      ELSEIF(I.EQ.3)THEN !FXY
         GAUSS = 4*X*Y*A*B*B*DEXP(-B*x**2 - B*y**2)
      ENDIF

      RETURN
      END

      FUNCTION NUMDERIV(X,Y,I,STEPX,STEPY)
      implicit none
      INTEGER I
      REAL*8 X,Y,XX(10),YY(10),STEPX,STEPY,NUMDERIV,GAUSS

      IF(I.EQ.1)THEN !FXX
         XX(1) = X + 2.0*STEPX
         XX(2) = X + STEPX
         XX(3) = X 
         XX(4) = X - STEPX
         XX(5) = X - 2.0*STEPX
         NUMDERIV = (-GAUSS(XX(1),Y,0) +16.0*GAUSS(XX(2),Y,0)
     &      -30.0*GAUSS(XX(3),Y,0) +16.0*GAUSS(XX(4),Y,0) 
     &      -GAUSS(XX(5),Y,0))/(12.0*STEPX**2)
      ELSEIF(I.EQ.2)THEN !FYY
         YY(1) = Y + 2.0*STEPY
         YY(2) = Y + STEPY
         YY(3) = Y 
         YY(4) = Y - STEPY
         YY(5) = Y - 2.0*STEPY
         NUMDERIV = (-GAUSS(X,YY(1),0) +16.0*GAUSS(X,YY(2),0)
     &      -30.0*GAUSS(X,YY(3),0) +16.0*GAUSS(X,YY(4),0) 
     &      -GAUSS(X,YY(5),0))/(12.0*STEPY**2)
      ELSEIF(I.EQ.3)THEN !FXY
         XX(1) = X + 2.0*STEPX
         XX(2) = X + STEPX
         XX(3) = X - STEPX
         XX(4) = X - 2.0*STEPX
         YY(1) = Y + 2.0*STEPY
         YY(2) = Y + STEPY
         YY(3) = Y - STEPY
         YY(4) = Y - 2.0*STEPY
         NUMDERIV =(16*GAUSS(XX(2),YY(2),0) 
     &      + 16*GAUSS(XX(3),YY(3),0) -GAUSS(XX(1),YY(1),0)
     &      -GAUSS(XX(4),YY(4),0) -16*GAUSS(XX(2),YY(3),0)
     &      -16*GAUSS(XX(3),YY(2),0) + GAUSS(XX(1),YY(4),0)
     &      + GAUSS(XX(4),YY(1),0))/(48.0*STEPX*STEPY)
      ENDIF

      RETURN
      END
      

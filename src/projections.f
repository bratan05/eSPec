      PROGRAM projections
      IMPLICIT NONE
*     ..
*     Purpose
*     =======
*     Compute the mean values, the norm of the wave packet and projections
*     of the wave packet in a set of given wave functions.
*
*     ..
*     Argumens
*     =========
*
*     ..
*     Authors
*     =======
*     Freddy Fernandes Guimaraes - email:freddy@ufmg.br
*
*     ..
*     Historic
*     ========
*     (01/03/2004) First version of projections written by Freddy
*     
c     **
c     ** Scalar arguments
      LOGICAL       ALL
      CHARACTER*16  INFILEWP, INFILEWF
      CHARACTER*72  CHLX
      INTEGER       I, J, K, IOTEST, NJ, IM, IFLTHWF, NF, NJWP
      REAL*8        XL, XIL, DT, XI, MOMENT, P2, TRAJEC, R2
      REAL*8        R, RA, RA1, RB, RB1, PAUX, P, NORM, SM
      REAL*8        DX
c     ** 
c     ** Parameters 
      INTEGER       NPR, NPRV, MPR
      REAL*8        ZERO, ONE
      PARAMETER     (NPR  = 9999, 
     &               NPRV = 13389,
c     &               NPRV = 438,
     &               MPR  = 50,
     &               ZERO = +0.0D+0,
     &               ONE  = +1.0D+0) 
c     **
c     ** Array arguments
      REAL*8        PROJC(MPR), PROJCR(MPR), PROJCI(MPR)
      REAL*8        UM(NPR,NPRV), VM(NPR,NPRV), UMI(MPR,NPRV)
c     **
c     ** External functions 
      INTEGER       ICHLENGTH
c     **
c     ** External subroutines 
c      EXTERNAL      
c     **
c     ** Intrinsic functions 
c      INTRINSIC     
c     ..
c     .. Starting program
c     ..
c     .. Starting integer local values
      ALL = .FALSE.
      INFILEWF = '   '
      INFILEWP = '   '
      SM = ONE
      
      write(*,*)'Type the WF file name'
      READ(*,*)INFILEWF
      write(*,*)'Type the WP file name'
      READ(*,*)INFILEWP 
c      write(*,*)'Type the mass of the system'
c      READ(*,*)SM
c     ..
c     .. Computing the size of the input file name
      IFLTHWF = ICHLENGTH(INFILEWF,0)
c     ..
c     .. Testing if it is necessary the computaion of the projections 
      IF(IFLTHWF.GT.0)ALL = .TRUE.
c      
      IF(ALL)THEN
         WRITE(*,1003)'Acquiring stationary wave functions...'
         OPEN(2, STATUS='OLD', FILE=INFILEWF(1:IFLTHWF), IOSTAT=IOTEST)
         IF(IOTEST.NE.ZERO)THEN
            WRITE(*,*)'<<<>>> Input file "', INFILEWF(1:IFLTHWF), 
     &           '" cannot be opened <<<>>>'
            WRITE(*,*)'Skiping the projections calculations'
            J = ZERO
            GOTO 20 
         ENDIF
         READ(2,'(A)',END=999,ERR=999)CHLX
         READ(2,*, END=999,ERR=10)XIL, (UMI(I,J), I=1,50,1)
 10      CONTINUE
         IM = I - ONE
         
         WRITE(*,*)'   Number of stationary wave functions =',IM
         DO J=2,NPR,1
            READ(2,*, END=20,ERR=999)XL, (UMI(I,J), I=1,IM,1)
         ENDDO
 20      CONTINUE
         NJ = J - 1
         WRITE(*,*)'   Each stationary wave function file contains',NJ,
     &        ' points.' 
c         WRITE(*,*)'   Number of points in the wave function:', NJ
         WRITE(*,*)'Stationary wave functions acquired.'
      ENDIF
c     
      CALL GETWPS(INFILEWP, NPR, NF, NJWP, DT, XI, DX, UM, VM)
c
      IF(ALL)THEN 
         IF(XI.NE.XIL .OR.  NJWP.NE.NJ)THEN
            WRITE(*,*)'Initial coordenate in the wave function:', XIL
            WRITE(*,*)'Initial coordenate in the wave packet:', XI
            WRITE(*,*)'Number of points in the wave function:', NJ
            WRITE(*,*)'Number of points in the wave packet:', NJWP 
            WRITE(*,*)'<<<>>> The files contain different coordinates for t
     &he initial wave functions and the wave packet <<<>>>'
            STOP
         ELSEIF(NJWP.NE.NJ)THEN   
            WRITE(*,*)'Number of points in the wave function:', NJ
            WRITE(*,*)'Number of points in the wave packet:', NJWP
            WRITE(*,*)'<<<>>> The files contain different coordinates for t
     &he initial wave functions and the wave packet <<<>>>'
            STOP
         ELSEIF(XI.NE.XIL)THEN 
            WRITE(*,*)'Initial coordenate in the wave function:', XIL
            WRITE(*,*)'Initial coordenate in the wave packet:', XI
            WRITE(*,*)'<<<>>> The files contain different coordinates for t
     &he initial wave functions and the wave packet <<<>>>'
            STOP
         ELSE
            CONTINUE
         ENDIF
      ENDIF
c
      WRITE(1,1032)('P(',K,')', K=1,IM,1)
      DO I=1,NF,1
         MOMENT = ZERO
         P2     = ZERO
         TRAJEC = ZERO
         R2     = ZERO
         NORM   = ZERO
         DO K=1,IM,1
            PROJCR(K) = ZERO
            PROJCI(K) = ZERO
         ENDDO
         DO J=1,NJ,1
            R = XI + (J - 1)*DX
            RA1 = XI + (J + 2)*DX
            RA = XI + J*DX
            RB = XI + (J - 2)*DX
            RB1 = XI + (J - 3)*DX
            IF(J.EQ.1)THEN
               RB  = ZERO
               RB1 = ZERO
            ELSEIF(J.EQ.2)THEN
               RB  = ZERO
            ELSEIF(J.EQ.NJ-1)THEN
               RA  = ZERO
            ELSEIF(J.EQ.NJ)THEN
               RA  = ZERO
               RA1 = ZERO
            ENDIF
            PAUX   = -RA1 + 1.6D1*RA - 3.0D1*R + 1.6D1*RB - RB1
            P      = PAUX/(12*DX*SM)
            MOMENT = MOMENT + UM(I,J)*P*UM(I,J)   + VM(I,J)*P*VM(I,J)
            P2     = P2     + UM(I,J)*P*P*UM(I,J) + VM(I,J)*P*P*VM(I,J)
            TRAJEC = TRAJEC + UM(I,J)*R*UM(I,J)   + VM(I,J)*R*VM(I,J)
            R2     = R2     + UM(I,J)*R*R*UM(I,J) + VM(I,J)*R*R*VM(I,J)
            NORM   = NORM   + UM(I,J)*UM(I,J)     + VM(I,J)*VM(I,J)
            IF(ALL)THEN
c               write(*,*)UMI(I,J),UM(I,J)
c               read(*,*)
               DO K=1,IM,1
                  PROJCR(K) = PROJCR(K) + UMI(K,J)*UM(I,J)
                  PROJCI(K) = PROJCI(K) + UMI(K,J)*VM(I,J)
               ENDDO
            ENDIF
         ENDDO
         DO K=1,IM,1
            PROJC(K) = PROJCR(K)**2 + PROJCI(K)**2
         ENDDO
         WRITE(1,1033)(I - ONE)*DT, TRAJEC, R2, MOMENT, P2, NORM, 
     &        (PROJC(K), K=1,IM,1)
      ENDDO
c
      STOP
c
 999  WRITE(*,*)'<<<>>> Reading file error, check and resubmit <<<>>>'
      WRITE(*,*)INFILEWF
      STOP
 1001 FORMAT(1X,G12.5,3X,E12.6,3X,E12.6)
 1003 FORMAT(/,3X,A68)   
 1032 FORMAT(5X,'t (fs)',5X,'<r>',5X,'<r^2>',5X,'<p>',5X,'<p^2>',
     &     5X,'|<y(t)|y(t)>|^2',5X,50(5X,A2,I2,A1))
 1033 FORMAT(F10.4,3X,4(G12.6,3X),F12.6,50(3X,E12.6))
c 1002 FORMAT(A14,G12.6)
c     ..
      END

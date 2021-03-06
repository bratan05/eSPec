      PROGRAM DipoleMoment
c     **
*     ..
*     Purpose
*     =======
*     Computation of the permanent and transition dipole
*
*     d_ij = <i|d|j>; i=0,1,... and j=0,1,...
*
*     ..
*     Description
*     ===========
*     This program computes the permanent and transition dipole 
*     moment. It is necessary to give the r dependece (r1 ... rN)
*     of the electronic dipole moment (dm) and the r dependence 
*     of the Mth eigenvectors (wfM), which can be calculated with 
*     eSPec. For this, it is necessary to create a input file
*     called dipol.dat which has a specific format: 
*
*     =================================================
*     #Comment line
*     r1  dm1
*     r2  dm2
*     .    .
*     .    .
*     rN  dmN
*     #Comment line
*     r1  wf0_1  wf1_1  wf2_1  .   .   .  wfM_1  *END*
*     r2  wf0_2  wf1_2  wf2_2  .   .   .  wfM_2 
*     .     .      .      .
*     .     .      .      .
*     rN  wf0_N  wf1_N  wf2_N  .   .   .  wfM_N
*     
*     ================================================= 
*     OBS: It is necessary to write '*END*' in the end of the
*     first line where is the eigen-vectors are given, as showed
*     above. The last line of the dipol.dat file must to be a white line.
*
*     1) compile it giving the comand: f77 -o dipol.x dipol.f
*     2) run it giving the comand: ./dipol.x > dipol.out
*
*     ..
*     Authors
*     =======
*     Freddy Fernandes Guimaraes and Viviane Costa Felissicimo.
*
*     ..
*     Historic
*     ========
*     (05/2004) First version written by Freddy 
*     (10/12/2004) Final version written by Viviane
*
c     **
c     ** Parameters 
      INTEGER      ZERO, ONE, MAXR, MAXC
      PARAMETER    (
     &     ZERO = 0.0D+0, 
     &     ONE = 1.0D+0, 
     &     MAXR = 1.0D+6, 
     &     MAXC = 4.0D+1
     &     )
c     **
c     ** Scalars 
      CHARACTER*72 LIXO
      INTEGER      NC, NL, I, J, K, IOTEST
      REAL*8       SK, SUM
c     **
c     ** Arrays
      REAL*8       V(MAXR,MAXC), DM(MAXR)
c     **
c     ** External functions 
cdel      LOGICAL
cdel      CHARACTER*
cdel      INTEGER       
cdel      REAL*8
c     **
c     ** External subroutines 
cdel      EXTERNAL      
c     **
c     ** Intrinsic functions 
cdel      INTRINSIC     
c     .. Start program         
      OPEN(1, STATUS='OLD', FILE='dipol.dat', IOSTAT=IOTEST)
      IF(IOTEST.NE.ZERO)THEN
         WRITE(*,*)'<<<>>> Input file "dipol.dat" ',
     &        'cannot be opened <<<>>>'
         STOP
      ENDIF
c
      READ(1,*)LIXO
      DO I=1,MAXR,1
         READ(1,*,ERR=10,END=999)SK, DM(I)
      ENDDO
 10   CONTINUE
      NL = I - ONE
      WRITE(*,*) '# Number of points:',NL
c
      READ(1,*,END=999,ERR=20)SK, (V(1,J), J=1,MAXC,1)
      WRITE(*,*)(V(1,J), J=1,MAXC,1)
 20   CONTINUE
      NC = J - ONE
      WRITE(*,*) '# Number of states:',NC
      DO I=2,NL,1
         READ(1,*,END=999,ERR=999)SK, (V(I,J), J=1,NC,1)
      ENDDO
c
c     DO I=1,NL,1
c     V(I,2) =-V(I,2)
c     ENDDO
c
      DO K=1,NC,1
         DO J=1,NC,1
            SUM = 0.0D+0
            DO I=1,NL,1
               SUM = SUM + V(I,K)*DM(I)*V(I,J)
            ENDDO
            WRITE(*,*)K-1,' -> ',J-1,SUM
         ENDDO
      ENDDO
c
      STOP
 999  WRITE(*,*)'Reading error in file "dipol.dat"!'
      STOP
c     
      END

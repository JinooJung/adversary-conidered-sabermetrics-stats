# Introduction
2023년 서울대학교 자연과학대학 동계 학부생연구인턴십 연구 "상대를 고려한 야구지표"의 코드를 포함한 Repsitory입니다.
비대칭적인 게임 구조(ex. 투수와 타자의 맞대결)의 반복에서 특정 사건(ex. 안타)의 발생 확률 혹은 발생 횟수를 지표로써 사용하고자 할때, 만났던 상대의 실력을 보정해주는 방식에 관한 연구입니다.

# Report
Not Uploaded yet.

# Files
해당 Repository에 포함된 파일들에 대한 설명은 다음과 같습니다.
- download_data.R : R package 'baseballr'을 이용하여 투수와 타자의 맞대결에 대한 정보가 담긴 데이터셋을 다운로드하고 가공하는 역할을 하는 코드
- csv 파일들 : 위 코드로 만든 연구용 데이터셋.
- requirements.txt : 해당 연구에 필요한 python library 정리본
- fitting_weighted_mean.py : Weighted Mean 방식(보고서 참고)을 이용한 적합을 하는 코드
- fitting_inv-logit_weighted_mean.py : Inv-logit Weighted Mean 방식(보고서 참고)을 이용한 적합을 하는 코드
- inference.ipynb : 보고서 내용에 포함된 분석을 한 코드
- ckpt 폴더 내 파일들 : 적합 후 추정된 모수들의 값을 포함한 pytorch state dictionary

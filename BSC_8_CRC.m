%% ���뼰У��λ����
n = 8;
data = randi([0 1], n, 1); %��������
ver = [1,0,0,0,0,0,1,1,1]'; %У����
m = [data; zeros(8,1)]; %�ڷ������ݾ�������Ӱ���һ�е������
[~, rema_1] = Mod_2(m, ver); %ģ2������������rema_1��
data_r = [data; rema_1]; %��ģ2����������ӵ�Ҫ���������±���ΪУ��λ�������ɵ���CRC������Ϊ�������������ŵ�
data_input=data';
flag = 1; 
%% �����ŵ����䲢У��
while 1   
    %�������ŵ�
    p0_0 = 0.2; 
    p1_0 = 0.1;
    %У��
    for i = 1: length(data_r)/2
        if data_r(i) == 0 %����0λ�Ƿ���ȷ����ȷ������һλ������ȷ��1
            if randsrc(1,1,[0 1;1-p0_0, p0_0]) == 1 %�����������ʵ���ŵ����������
                data_r(i) = 1;
            end
        else
            if randsrc(1,1,[0 1;1-p1_0, p1_0]) == 1 %����1λ�Ƿ���ȷ����ȷ������һλ������ȷ��0
                data_r(i) = 0;
            end
            
        end
        
    end
    [~, rema_crc] = Mod_2(data_r, ver); %��־λ��ֵ
    flag = sum(rema_crc);
   
 %% �ж������Ƿ��д�
    if flag ~= 0
        disp('���δ����д�Ҫ���ش�');
    else
        disp('���δ�����ȷ')
        break;
    end
end
a_num=(data_r(1:n))';
msgbox({ '���룺',num2str(data_input),'�����',num2str(a_num)},'������','help')

%%  ģ2������
function [quo, rema] = Mod_2(b, a)
quo = []; %�̾���
rema = []; %��������
leng1 = length(b);
leng2 = length(a);
for i = 1: leng1-leng2+1
    if b(i) == 0
        quo = [quo, 0];
    else
        quo = [quo, 1];
        b(i:i+leng2-1) = xor(b(i:i+leng2-1), a);
    end
end
rema = b(end-leng2+2: end);
end


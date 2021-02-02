#
require_relative '../../services/message_processor'

describe MessageProcessor do
  describe 'processando' do
    context 'todas as mensagens processadas' do
      it 'todas processadas' do
        output = '525810ca-e45d-4146-900c-b6be6caa3c7b,7eaa49ac-f52b-49e3-9e07-6501d0f28c30,89892de7-06fa-4c52-880b-6d9e1ddc951e,bf649f66-ac02-45fe-8f24-d08934584a31'
        messages = [
          "baa73193-bf00-4e6c-b63b-c037679392e3,proposal,created,2019-11-11T21:03:12Z,525810ca-e45d-4146-900c-b6be6caa3c7b,472459.0,72",
          "a739acb6-4d62-418a-980f-90b916fd72ca,warranty,added,2019-11-11T21:03:12Z,525810ca-e45d-4146-900c-b6be6caa3c7b,76bd2fc5-d94b-46e3-8bab-c482ec3c8714,1256696.2,BA",
          "8e2a1065-e26c-4d3b-a8e1-1a52fd153001,warranty,added,2019-11-11T21:03:12Z,525810ca-e45d-4146-900c-b6be6caa3c7b,bbeea6f8-149a-435b-a4d7-7e6003e93f1c,1110109.8,BA",
          "d00901a1-06b2-4a99-816e-f4c782a6d961,proponent,added,2019-11-11T21:03:12Z,525810ca-e45d-4146-900c-b6be6caa3c7b,9a34b4d1-f688-434f-97a8-dc9c91ccd2e5,Jackie D'Amore,63,54124.05,true",
          "c7d3235c-dd3c-43f1-a168-3faef53f90f4,proponent,added,2019-11-11T21:03:12Z,525810ca-e45d-4146-900c-b6be6caa3c7b,c2244882-fc28-4005-9f82-82ae85b2ca4a,Ms. Morton Wuckert,18,46981.78,false",
          "4143bdcf-91a0-4bb0-a5ae-71bb887334be,proposal,created,2019-11-11T21:03:12Z,7eaa49ac-f52b-49e3-9e07-6501d0f28c30,462510.0,24",
          "30bb8202-7d4d-4542-9b76-037bbecf3819,warranty,added,2019-11-11T21:03:12Z,7eaa49ac-f52b-49e3-9e07-6501d0f28c30,57a9c38a-d3b9-4fbf-bcca-c3f0cb917cbd,964736.34,BA",
          "0ed65980-454e-456d-a9a4-bfb6a6d4fe14,warranty,added,2019-11-11T21:03:12Z,7eaa49ac-f52b-49e3-9e07-6501d0f28c30,28c2820a-b0b4-43ff-bde9-5ca8eaa89331,1121990.97,BA",
          "3062e3a3-9d9e-4ea0-a3cc-d505db5fefe7,proponent,added,2019-11-11T21:03:12Z,7eaa49ac-f52b-49e3-9e07-6501d0f28c30,b88fcd8d-a06d-4fb6-a1ab-8f5969cdca8d,Barbara Gutmann,65,146891.48,true",
          "99cb1103-e835-4572-8beb-fb646c87ba61,proponent,added,2019-11-11T21:03:12Z,7eaa49ac-f52b-49e3-9e07-6501d0f28c30,270f5c3c-07c0-4f21-8211-0b7269f4a6b1,Letitia Beahan,39,131284.88,false",
          "25d963ed-92cf-4161-a04f-f7e227865b0a,proposal,created,2019-11-11T21:03:12Z,89892de7-06fa-4c52-880b-6d9e1ddc951e,657250.0,180",
          "6c8150ee-c034-4064-8fa5-a0ffec810bcd,warranty,added,2019-11-11T21:03:12Z,89892de7-06fa-4c52-880b-6d9e1ddc951e,a86ec059-d928-44dd-86bb-faceac45f86f,1728052.71,BA",
          "653286f8-5895-48cb-b0a5-2c8ed42aa7ce,warranty,added,2019-11-11T21:03:12Z,89892de7-06fa-4c52-880b-6d9e1ddc951e,74567b84-0d36-4e09-8c34-3d83113d0cab,1904792.27,ES",
          "5b924f17-f2a9-4bdf-97da-b57a4f49c615,proponent,added,2019-11-11T21:03:12Z,89892de7-06fa-4c52-880b-6d9e1ddc951e,4ee3e203-5afb-43e5-a627-22973b2f566c,Alexis Altenwerth I,44,21305.38,true",
          "5b924f17-f2a9-4bdf-97da-b57a4f49c615,proponent,updated,2019-11-11T21:04:12Z,89892de7-06fa-4c52-880b-6d9e1ddc951e,4ee3e203-5afb-43e5-a627-22973b2f566c,Alexis Altenwerth I,12,21305.38,true",
          "fd6269f6-f1f4-4f96-8f42-91898b451bc9,proponent,added,2019-11-11T21:03:12Z,89892de7-06fa-4c52-880b-6d9e1ddc951e,dd269078-0850-4c91-802e-ae06e734e334,Bethann Kling V,59,19874.87,false",
          "21a08775-9ca1-4811-b188-dcd0fcee5378,proposal,created,2019-11-11T21:03:12Z,bf649f66-ac02-45fe-8f24-d08934584a31,2545960.0,168",
          "c8203cc6-d5c6-4929-aa77-a065d96d9dd0,warranty,added,2019-11-11T21:03:12Z,bf649f66-ac02-45fe-8f24-d08934584a31,9865612a-e523-4fd4-985f-51f1c2f274c4,5895564.67,BA",
          "71c42789-4b10-4166-9ea2-13e5487fac63,warranty,added,2019-11-11T21:03:12Z,bf649f66-ac02-45fe-8f24-d08934584a31,8c9d9958-21b5-4634-a474-d414f4aeb159,6713742.36,DF",
          "b2135441-c4b3-4134-8c6f-a60a5c152f31,proponent,added,2019-11-11T21:03:12Z,bf649f66-ac02-45fe-8f24-d08934584a31,13a1d7e5-9456-4ee2-81dc-96a9d8583af3,Nan Dach,27,95570.71,true",
          "1d217db7-3543-4761-b4e6-6cd6d00c3fdb,proponent,added,2019-11-11T21:03:12Z,bf649f66-ac02-45fe-8f24-d08934584a31,38dd1836-7657-40a9-a88c-bbaa4a4924a4,Angel Medhurst,42,120104.9,false"
        ]

        subject = described_class.new.process(messages)
        expect(subject).to eq output
      end
    end
  end
end
